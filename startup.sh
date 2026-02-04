#!/bin/sh

HTML_FILE="/usr/share/nginx/html/index.html"

echo "Starting environment variable replacement in $HTML_FILE..."

replace_placeholder() {
  placeholder=$1
  value=$2

  # Escape slashes and ampersands for sed
  escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')

  sed -i "s|{{${placeholder}}}|${escaped_value}|g" "$HTML_FILE"
}

remove_block() {
  block_name=$1
  sed -i "/<!-- ${block_name}_BLOCK_START -->/,/<!-- ${block_name}_BLOCK_END -->/d" "$HTML_FILE"
}

is_true() {
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
    true) return 0 ;;
    *) return 1 ;;
  esac
}

# Load environment variables or defaults
LOGO_URL="${LOGO_URL:-}"
TITLE="${TITLE:-Parking Page}"
SHOW_TITLE="${SHOW_TITLE:-true}"
SUBTEXT="${SUBTEXT:-}"

EMAIL="${EMAIL:-}"
LINK_EMAIL="${LINK_EMAIL:-}"

PHONE="${PHONE:-}"
LINK_PHONE="${LINK_PHONE:-}"

CREDIT_LOGO_URL="${CREDIT_LOGO_URL:-https://s3.sa-east-1.amazonaws.com/envio.icc.gg/logo_256x256-7ds3h.png}"
CREDIT_LINK="${CREDIT_LINK:-https://ivancarlos.com.br/}"

FAVICON_PNG_URL="${FAVICON_PNG_URL:-/favicon-96x96.png}"
FAVICON_SVG_URL="${FAVICON_SVG_URL:-/favicon.svg}"
FAVICON_ICO_URL="${FAVICON_ICO_URL:-/favicon.ico}"
APPLE_TOUCH_ICON_URL="${APPLE_TOUCH_ICON_URL:-/apple-touch-icon.png}"

# HTML placeholders replacement and conditional blocks

if [ -z "$LOGO_URL" ]; then
  remove_block "LOGO"
else
  replace_placeholder "LOGO_URL" "$LOGO_URL"
fi

# Always replace <title> and apple-mobile-web-app-title meta content
replace_placeholder "TITLE" "$TITLE"

# Conditionally show/hide <h1>{{TITLE}}</h1> block
if is_true "$SHOW_TITLE" && [ -n "$TITLE" ]; then
  replace_placeholder "TITLE" "$TITLE"
else
  remove_block "TITLE"
fi

if [ -z "$SUBTEXT" ]; then
  remove_block "SUBTEXT"
else
  replace_placeholder "SUBTEXT" "$SUBTEXT"
fi

if [ -z "$EMAIL" ]; then
  remove_block "EMAIL"
else
  if [ -z "$LINK_EMAIL" ]; then
    LINK_EMAIL="mailto:$EMAIL"
  fi
  replace_placeholder "EMAIL" "$EMAIL"
  replace_placeholder "LINK_EMAIL" "$LINK_EMAIL"
fi

if [ -z "$PHONE" ] || [ -z "$LINK_PHONE" ]; then
  remove_block "PHONE"
else
  replace_placeholder "PHONE" "$PHONE"
  replace_placeholder "LINK_PHONE" "$LINK_PHONE"
fi

replace_placeholder "CREDIT_LOGO_URL" "$CREDIT_LOGO_URL"
replace_placeholder "CREDIT_LINK" "$CREDIT_LINK"

replace_placeholder "FAVICON_PNG_URL" "$FAVICON_PNG_URL"
replace_placeholder "FAVICON_SVG_URL" "$FAVICON_SVG_URL"
replace_placeholder "FAVICON_ICO_URL" "$FAVICON_ICO_URL"
replace_placeholder "APPLE_TOUCH_ICON_URL" "$APPLE_TOUCH_ICON_URL"

# -----------------------------
# Generate security.txt from template
# -----------------------------

generate_security_txt() {
  TEMPLATE_FILE="/usr/share/nginx/html/.well-known/security.txt.template"
  OUTPUT_FILE="/usr/share/nginx/html/.well-known/security.txt"

  CONTACT_LINK1="${CONTACT_LINK1:-}"
  CONTACT_LINK2="${CONTACT_LINK2:-}"
  CONTACT_LINK3="${CONTACT_LINK3:-}"
  LANG="${LANG:-}"
  POLICY="${POLICY:-}"
  EXPIREDATE_ISO="${EXPIREDATE_ISO:-}"

  # Check required vars
  if [ -z "$EXPIREDATE_ISO" ]; then
    echo "EXPIREDATE_ISO not set. Skipping security.txt generation."
    rm -f "$TEMPLATE_FILE"
    return
  fi

  if [ -z "$CONTACT_LINK1" ] && [ -z "$CONTACT_LINK2" ] && [ -z "$CONTACT_LINK3" ]; then
    echo "No CONTACT_LINK variables set. Skipping security.txt generation."
    rm -f "$TEMPLATE_FILE"
    return
  fi

  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Template file $TEMPLATE_FILE not found. Skipping security.txt generation."
    return
  fi

  cp "$TEMPLATE_FILE" "$OUTPUT_FILE"

  replace_in_file() {
    local placeholder=$1
    local value=$2
    local file=$3
    local escaped
    escaped=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')
    sed -i "s|{{${placeholder}}}|${escaped}|g" "$file"
  }

  for i in 1 2 3; do
    val=$(eval echo \${CONTACT_LINK$i})
    if [ -z "$val" ]; then
      sed -i "/{{CONTACT_LINK${i}}}/d" "$OUTPUT_FILE"
    else
      replace_in_file "CONTACT_LINK${i}" "$val" "$OUTPUT_FILE"
    fi
  done

  if [ -z "$LANG" ]; then
    sed -i "/{{LANG}}/d" "$OUTPUT_FILE"
  else
    replace_in_file "LANG" "$LANG" "$OUTPUT_FILE"
  fi

  if [ -z "$POLICY" ]; then
    sed -i "/{{POLICY}}/d" "$OUTPUT_FILE"
  else
    replace_in_file "POLICY" "$POLICY" "$OUTPUT_FILE"
  fi

  replace_in_file "EXPIREDATE_ISO" "$EXPIREDATE_ISO" "$OUTPUT_FILE"

  echo "security.txt generated at $OUTPUT_FILE"

  # Delete template after processing
  rm -f "$TEMPLATE_FILE"
}

generate_security_txt

echo "Replacement done."

echo "Starting nginx..."

exec nginx -g 'daemon off;'

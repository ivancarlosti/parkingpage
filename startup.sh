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

# Helper function to check if string is equal to true (case-insensitive)
is_true() {
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
    true) return 0 ;;
    *) return 1 ;;
  esac
}

# Load env variables or empty string
LOGO_URL="${LOGO_URL:-}"
TITLE="${TITLE:-Parking Page}"
SHOW_TITLE="${SHOW_TITLE:-true}"  # default show true
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

# LOGO
if [ -z "$LOGO_URL" ]; then
  remove_block "LOGO"
else
  replace_placeholder "LOGO_URL" "$LOGO_URL"
fi

# Always replace <title> and apple-mobile-web-app-title meta content
replace_placeholder "TITLE" "$TITLE"

# Conditionally replace or remove visible title <h1>{{TITLE}}</h1> block below logo
if is_true "$SHOW_TITLE" && [ -n "$TITLE" ]; then
  replace_placeholder "TITLE" "$TITLE"
else
  remove_block "TITLE"
fi

# SUBTEXT
if [ -z "$SUBTEXT" ]; then
  remove_block "SUBTEXT"
else
  replace_placeholder "SUBTEXT" "$SUBTEXT"
fi

# EMAIL block
if [ -z "$EMAIL" ]; then
  remove_block "EMAIL"
else
  # Fallback mailto link if LINK_EMAIL not set
  if [ -z "$LINK_EMAIL" ]; then
    LINK_EMAIL="mailto:$EMAIL"
  fi
  replace_placeholder "EMAIL" "$EMAIL"
  replace_placeholder "LINK_EMAIL" "$LINK_EMAIL"
fi

# PHONE and LINK_PHONE block
if [ -z "$PHONE" ] || [ -z "$LINK_PHONE" ]; then
  remove_block "PHONE"
else
  replace_placeholder "PHONE" "$PHONE"
  replace_placeholder "LINK_PHONE" "$LINK_PHONE"
fi

# CREDIT
replace_placeholder "CREDIT_LOGO_URL" "$CREDIT_LOGO_URL"
replace_placeholder "CREDIT_LINK" "$CREDIT_LINK"

# FAVICONS
replace_placeholder "FAVICON_PNG_URL" "$FAVICON_PNG_URL"
replace_placeholder "FAVICON_SVG_URL" "$FAVICON_SVG_URL"
replace_placeholder "FAVICON_ICO_URL" "$FAVICON_ICO_URL"
replace_placeholder "APPLE_TOUCH_ICON_URL" "$APPLE_TOUCH_ICON_URL"

echo "Replacement done, starting nginx..."

exec nginx -g 'daemon off;'

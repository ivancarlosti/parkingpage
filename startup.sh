#!/bin/sh

# Base directories
BASE_HTML_DIR="/usr/share/nginx/html"
CONFIG_DIR="/config/sites"
NGINX_CONF_DIR="/etc/nginx/conf.d"

# Keep a pristine copy of the original template for cloning
if [ ! -d "/usr/share/nginx/html.template" ]; then
    cp -r /usr/share/nginx/html /usr/share/nginx/html.template
fi

process_site() {
  local SITE_NAME=$1
  local TARGET_DIR=$2

  export HTML_FILE="${TARGET_DIR}/index.html"

  echo "Processing site: $SITE_NAME at $TARGET_DIR..."

  replace_placeholder() {
    placeholder=$1
    value=$2
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

  if [ -z "$LOGO_URL" ]; then remove_block "LOGO"; else replace_placeholder "LOGO_URL" "$LOGO_URL"; fi
  replace_placeholder "TITLE" "$TITLE"
  if is_true "$SHOW_TITLE" && [ -n "$TITLE" ]; then replace_placeholder "TITLE" "$TITLE"; else remove_block "TITLE"; fi
  if [ -z "$SUBTEXT" ]; then remove_block "SUBTEXT"; else replace_placeholder "SUBTEXT" "$SUBTEXT"; fi
  if [ -z "$EMAIL" ]; then remove_block "EMAIL"; else
    if [ -z "$LINK_EMAIL" ]; then LINK_EMAIL="mailto:$EMAIL"; fi
    replace_placeholder "EMAIL" "$EMAIL"
    replace_placeholder "LINK_EMAIL" "$LINK_EMAIL"
  fi
  if [ -z "$PHONE" ] || [ -z "$LINK_PHONE" ]; then remove_block "PHONE"; else
    replace_placeholder "PHONE" "$PHONE"
    replace_placeholder "LINK_PHONE" "$LINK_PHONE"
  fi
  replace_placeholder "CREDIT_LOGO_URL" "$CREDIT_LOGO_URL"
  replace_placeholder "CREDIT_LINK" "$CREDIT_LINK"
  replace_placeholder "FAVICON_PNG_URL" "$FAVICON_PNG_URL"
  replace_placeholder "FAVICON_SVG_URL" "$FAVICON_SVG_URL"
  replace_placeholder "FAVICON_ICO_URL" "$FAVICON_ICO_URL"
  replace_placeholder "APPLE_TOUCH_ICON_URL" "$APPLE_TOUCH_ICON_URL"

  generate_security_txt() {
    TEMPLATE_FILE="${TARGET_DIR}/.well-known/security.txt.template"
    OUTPUT_FILE="${TARGET_DIR}/.well-known/security.txt"

    CONTACT_LINK1="${CONTACT_LINK1:-}"
    CONTACT_LINK2="${CONTACT_LINK2:-}"
    CONTACT_LINK3="${CONTACT_LINK3:-}"
    LANG="${LANG:-}"
    POLICY="${POLICY:-}"
    EXPIREDATE_ISO="${EXPIREDATE_ISO:-}"

    if [ -z "$EXPIREDATE_ISO" ]; then rm -f "$TEMPLATE_FILE"; return; fi
    if [ -z "$CONTACT_LINK1" ] && [ -z "$CONTACT_LINK2" ] && [ -z "$CONTACT_LINK3" ]; then rm -f "$TEMPLATE_FILE"; return; fi
    if [ ! -f "$TEMPLATE_FILE" ]; then return; fi

    cp "$TEMPLATE_FILE" "$OUTPUT_FILE"

    replace_in_file() {
      local p=$1
      local v=$2
      local f=$3
      local e
      e=$(printf '%s\n' "$v" | sed -e 's/[\/&]/\\&/g')
      sed -i "s|{{${p}}}|${e}|g" "$f"
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
    rm -f "$TEMPLATE_FILE"
  }

  generate_security_txt

  if [ "$SITE_NAME" != "default" ]; then
    SERVER_NAME="${SERVER_NAME:-$SITE_NAME}"
    if [ -n "$DOMAINS" ]; then
      # Convert commas to spaces (for backwards compatibility) and squeeze consecutive spaces
      SERVER_NAME=$(echo "$DOMAINS" | tr ',' ' ' | tr -s ' ')
    fi
    cat > "$NGINX_CONF_DIR/${SITE_NAME}.conf" <<EOF
server {
    listen 80;
    server_name ${SERVER_NAME};
    root ${TARGET_DIR};
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
    echo "Generated Nginx config for $SERVER_NAME at $NGINX_CONF_DIR/${SITE_NAME}.conf"
  fi
}

mkdir -p "$NGINX_CONF_DIR"

if [ -d "$CONFIG_DIR" ] && [ "$(ls -A $CONFIG_DIR/*.env 2>/dev/null)" ]; then
  echo "Multi-site configuration detected in $CONFIG_DIR"
  for env_file in "$CONFIG_DIR"/*.env; do
    site_name=$(basename "$env_file" .env)
    target_dir="$BASE_HTML_DIR/$site_name"

    echo "Setting up site: $site_name"
    
    rm -rf "$target_dir"
    cp -r /usr/share/nginx/html.template "$target_dir"

    (
      # Parse .env file safely without executing it to handle unquoted spaces
      while IFS= read -r line || [ -n "$line" ]; do
        # Ignore comments and empty lines
        case "$line" in
          \#*|"") continue ;;
        esac
        # Extract key and value
        key="${line%%=*}"
        value="${line#*=}"
        # Remove surrounding quotes from value if present
        value="${value%\"}"
        value="${value#\"}"
        value="${value%\'}"
        value="${value#\'}"
        export "$key"="$value"
      done < "$env_file"
      
      process_site "$site_name" "$target_dir"
    )
  done

  # Clean the default root to avoid serving the unconfigured template
  rm -f "$BASE_HTML_DIR/index.html"
else
  echo "Single-site configuration detected."
  cp -r /usr/share/nginx/html.template/* /usr/share/nginx/html/
  (
    process_site "default" "$BASE_HTML_DIR"
  )
fi

echo "Replacement done."
echo "Starting nginx..."
exec nginx -g 'daemon off;'

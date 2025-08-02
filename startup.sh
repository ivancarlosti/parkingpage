#!/bin/sh

# Path to the HTML file with placeholders
HTML_FILE="/usr/share/nginx/html/index.html"

echo "Starting environment variable replacement in $HTML_FILE..."

replace_placeholder() {
  placeholder=$1
  value=$2

  # Escape slashes, ampersands, and other sed special chars in the replacement value
  escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')

  # Replace all occurrences of {{PLACEHOLDER}} with the escaped value
  sed -i "s|{{${placeholder}}}|${escaped_value}|g" "$HTML_FILE"
}

# Debug info: Print current env vars (optional)
echo "Environment variables used for replacement:"
echo "LOGO_URL=$LOGO_URL"
echo "TITLE=$TITLE"
echo "SUBTEXT=$SUBTEXT"
echo "EMAIL=$EMAIL"
echo "PHONE=$PHONE"
echo "WHATSAPP_LINK=$WHATSAPP_LINK"
echo "CREDIT_LOGO_URL=$CREDIT_LOGO_URL"
echo "CREDIT_LINK=$CREDIT_LINK"
echo "FAVICON_PNG_URL=$FAVICON_PNG_URL"
echo "FAVICON_SVG_URL=$FAVICON_SVG_URL"
echo "FAVICON_ICO_URL=$FAVICON_ICO_URL"
echo "APPLE_TOUCH_ICON_URL=$APPLE_TOUCH_ICON_URL"

# Replace placeholders with environment variable values or defaults
replace_placeholder "LOGO_URL" "${LOGO_URL:-logo.png}"
replace_placeholder "TITLE" "${TITLE:-Parking Page}"
replace_placeholder "SUBTEXT" "${SUBTEXT:-Under Construction}"
replace_placeholder "EMAIL" "${EMAIL:-email@example.com}"
replace_placeholder "PHONE" "${PHONE:-+55 11 9XXXX-XXXX}"
replace_placeholder "WHATSAPP_LINK" "${WHATSAPP_LINK:-https://wa.me/55119XXXXXXXX}"
replace_placeholder "CREDIT_LOGO_URL" "${CREDIT_LOGO_URL:-https://s3.sa-east-1.amazonaws.com/envio.icc.gg/logo_256x256-7ds3h.png}"
replace_placeholder "CREDIT_LINK" "${CREDIT_LINK:-https://ivancarlos.com.br/}"
replace_placeholder "FAVICON_PNG_URL" "${FAVICON_PNG_URL:-/favicon-96x96.png}"
replace_placeholder "FAVICON_SVG_URL" "${FAVICON_SVG_URL:-/favicon.svg}"
replace_placeholder "FAVICON_ICO_URL" "${FAVICON_ICO_URL:-/favicon.ico}"
replace_placeholder "APPLE_TOUCH_ICON_URL" "${APPLE_TOUCH_ICON_URL:-/apple-touch-icon.png}"

echo "Replacement done, starting nginx..."

# Start Nginx in foreground (adjust if your image uses a different command)
exec nginx -g 'daemon off;'

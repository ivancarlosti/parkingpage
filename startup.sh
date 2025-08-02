#!/bin/sh

HTML_FILE="/usr/share/nginx/html/index.html"

replace_placeholder() {
  placeholder=$1
  value=$2

  # Escape slashes and ampersands for sed substitution
  escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')

  sed -i "s|{{${placeholder}}}|${escaped_value}|g" "$HTML_FILE"
}

remove_block() {
  block_name=$1
  # Delete everything between the block start and block end comments, inclusive
  sed -i "/<!-- ${block_name}_BLOCK_START -->/,/<!-- ${block_name}_BLOCK_END -->/d" "$HTML_FILE"
}

# Example environment variables with defaults or empty string (empty means hide)

LOGO_URL="${LOGO_URL:-}"
SUBTEXT="${SUBTEXT:-}"
EMAIL="${EMAIL:-}"
PHONE="${PHONE:-}"
WHATSAPP_LINK="${WHATSAPP_LINK:-}"

# Process LOGO_URL
if [ -z "$LOGO_URL" ]; then
  remove_block "LOGO"
else
  replace_placeholder "LOGO_URL" "$LOGO_URL"
fi

# Process SUBTEXT
if [ -z "$SUBTEXT" ]; then
  remove_block "SUBTEXT"
else
  replace_placeholder "SUBTEXT" "$SUBTEXT"
fi

# Process EMAIL
if [ -z "$EMAIL" ]; then
  remove_block "EMAIL"
else
  replace_placeholder "EMAIL" "$EMAIL"
fi

# Process PHONE and WHATSAPP_LINK together (as they display in same span)
if [ -z "$PHONE" ] || [ -z "$WHATSAPP_LINK" ]; then
  remove_block "PHONE"
else
  replace_placeholder "PHONE" "$PHONE"
  replace_placeholder "WHATSAPP_LINK" "$WHATSAPP_LINK"
fi

# ...now process the remaining placeholders normally:

replace_placeholder "TITLE" "${TITLE:-Gabriel Rosa Arquitetura}"
replace_placeholder "CREDIT_LOGO_URL" "${CREDIT_LOGO_URL:-https://s3.sa-east-1.amazonaws.com/envio.icc.gg/seeig5j8jnoc.png}"
replace_placeholder "CREDIT_LINK" "${CREDIT_LINK:-https://ivancarlos.com.br/}"

replace_placeholder "FAVICON_PNG_URL" "${FAVICON_PNG_URL:-/favicon-96x96.png}"
replace_placeholder "FAVICON_SVG_URL" "${FAVICON_SVG_URL:-/favicon.svg}"
replace_placeholder "FAVICON_ICO_URL" "${FAVICON_ICO_URL:-/favicon.ico}"
replace_placeholder "APPLE_TOUCH_ICON_URL" "${APPLE_TOUCH_ICON_URL:-/apple-touch-icon.png}"

# Finally, start nginx
exec nginx -g 'daemon off;'

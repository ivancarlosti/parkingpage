#!/bin/sh

HTML_FILE="/usr/share/nginx/html/index.html"

replace_placeholder() {
  # $1 = placeholder (e.g. LOGO_URL)
  # $2 = value to replace
  sed -i "s|{{${1}}}|${2}|g" "$HTML_FILE"
}

# Replace all placeholders with env var values (or fallback to empty string)
replace_placeholder "LOGO_URL" "${LOGO_URL:-}"
replace_placeholder "TITLE" "${TITLE:-}"
replace_placeholder "SUBTEXT" "${SUBTEXT:-}"
replace_placeholder "EMAIL" "${EMAIL:-}"
replace_placeholder "PHONE" "${PHONE:-}"
replace_placeholder "WHATSAPP_LINK" "${WHATSAPP_LINK:-}"
replace_placeholder "CREDIT_LOGO_URL" "${CREDIT_LOGO_URL:-}"
replace_placeholder "CREDIT_LINK" "${CREDIT_LINK:-}"
replace_placeholder "FAVICON_PNG_URL" "${FAVICON_PNG_URL:-}"
replace_placeholder "FAVICON_SVG_URL" "${FAVICON_SVG_URL:-}"
replace_placeholder "FAVICON_ICO_URL" "${FAVICON_ICO_URL:-}"
replace_placeholder "APPLE_TOUCH_ICON_URL" "${APPLE_TOUCH_ICON_URL:-}"

# Start the server (example with nginx)
exec nginx -g 'daemon off;'

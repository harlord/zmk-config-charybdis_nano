# WARNING. THIS FILE IS AUTO-GENERATED. DO NOT MODIFY!
#
# This file contains build system settings derived from your snippets.
# Its contents are an implementation detail that should not be used outside
# of Zephyr's snippets CMake module.
#
# See the Snippets guide in the Zephyr documentation for more information.

###############################################################################
# Global information about all snippets.

# The name of every snippet that was discovered.
set(SNIPPET_NAMES "cdc-acm-console" "nrf52833-nosd" "nrf52840-nosd" "studio-rpc-usb-uart" "xen_dom0" "zmk-usb-logging")
# The paths to all the snippet.yml files. One snippet
# can have multiple snippet.yml files.
set(SNIPPET_PATHS "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zephyr/snippets/cdc-acm-console/snippet.yml" "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zephyr/snippets/xen_dom0/snippet.yml" "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/nrf52833-nosd/snippet.yml" "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/nrf52840-nosd/snippet.yml" "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/studio-rpc-usb-uart/snippet.yml" "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/zmk-usb-logging/snippet.yml")

# Create variable scope for snippets build variables
zephyr_create_scope(snippets)

###############################################################################
# Snippet 'zmk-usb-logging'

# Common variable appends.
zephyr_set(EXTRA_CONF_FILE "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/zmk-usb-logging/zmk-usb-logging.conf" SCOPE snippets APPEND)
zephyr_set(EXTRA_DTC_OVERLAY_FILE "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/zmk-usb-logging/zmk-usb-logging.overlay" SCOPE snippets APPEND)

###############################################################################
# Snippet 'studio-rpc-usb-uart'

# Common variable appends.
zephyr_set(DTS_EXTRA_CPPFLAGS "-DZMK_BEHAVIORS_KEEP_ALL" SCOPE snippets APPEND)
zephyr_set(EXTRA_DTC_OVERLAY_FILE "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/studio-rpc-usb-uart/studio-rpc-usb-uart.overlay" SCOPE snippets APPEND)
zephyr_set(EXTRA_CONF_FILE "/Users/haroldhernandez/Charybdis/zmk-config-charybdis_nano/zmk/app/snippets/studio-rpc-usb-uart/studio-rpc-usb-uart.conf" SCOPE snippets APPEND)


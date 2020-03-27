#**
#** Name   : vpn_ccu_monitor_irule
#** Author : brett-at-f5
#** Description: Used in conjunction with vpn_ccu_monitor.pl
#** Version: 1.0
#**

when HTTP_REQUEST {
  switch [string tolower [HTTP::path]] {
    "/offline" {
      table set -subtable ccu monitor offline indef indef
      HTTP::respond 200 content "offline"
    }
    "/online" {
      table set -subtable ccu monitor online indef indef
      HTTP::respond 200 content "online"
    }
    "/monitor" {
      set response [table lookup -subtable ccu monitor]
      HTTP::respond 200 content $response 
    }
    default { HTTP::close }
  }
}

/*
UDPServer.pde - UDP server Arduino processing sketch

Copyright (C) 2012 DIYSandbox LLC

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <Wirefree.h>
#include <WifiServer.h>

WIFI_PROFILE wireless_prof = {
                        /* SSID */ "diysandbox",
         /* WPA/WPA2 passphrase */ "12345678",
                  /* IP address */ "192.168.1.1",
                 /* subnet mask */ "255.255.255.0",
                  /* Gateway IP */ "192.168.1.1", };

WifiServer server(12345, PROTO_UDP);

void setup()
{
  // connect to AP & start server
  Wireless.begin(&wireless_prof, AP_MODE);
  server.begin();
  
  delay(1000);
}

void loop()
{
  // Listen for incoming clients
  WifiClient client = server.available();

  if (client) {
    // if there are incoming bytes available
    // from the peer device, read them and print them:
    while (client.available()) {
      int in;

      while ((in = client.read()) == -1);

      Serial.print((char)in);

      if (in == 0xa)
          break;
    }

    // Send message over UDP socket to peer device
    client.println("Hello client!");

    delay(1);
  }
}

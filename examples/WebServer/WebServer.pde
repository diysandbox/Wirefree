/*
WebServer.pde - Web server Arduino processing sketch

Copyright (C) 2011 DIYSandbox LLC

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
#include <Server.h>

WIFI_PROFILE w_prof = { "Cisco32371",       /* SSID */
                        "12345678" ,        /* WPA/WPA2 passphrase */
                        "192.168.1.109" ,   /* IP address */
                        "255.255.255.0" ,   /* subnet mask */
                        "192.168.1.1"   ,   /* Gateway IP */
                      };

// port 80 is default for HTTP
Server server(80);

void parseRxData(String data)
{
}

void setup()
{
  // connect to AP & start server
  Wireless.begin(&w_prof, &parseRxData);
  server.begin();
  
  delay(1000);
}

void loop()
{
  // Listen for incoming clients
  Client client = server.available();
  if (client) {
    // an HTTP request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c; 
        int  b; 
        
        while((b = client.read()) == -1);
        c = b;
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          // send a standard http response header

          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");     
          client.println("");     
          //client.println("");     
           
          
          // Output a simple basic HTML page
          client.println("<html><body>");
          client.println("<h1>DIYSandbox</h1>");
          client.write('M');
          client.println("<p>Hello World...</p>");
          client.println("</body></html>");

          break;         
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } 
        else if (c != '\r'){
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection         
    client.stop();            
  }
}



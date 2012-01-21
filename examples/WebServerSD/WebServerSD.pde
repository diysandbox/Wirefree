/*
WebServerSD.pde - Web server & SD Arduino processing sketch
 
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
#include <WifiServer.h>
#include <SD.h>

File myFile;

WIFI_PROFILE w_prof = { "Cisco32371",       /* SSID */
                        "12345678" ,        /* WPA/WPA2 passphrase */
                        "192.168.1.109" ,   /* IP address */
                        "255.255.255.0" ,   /* subnet mask */
                        "192.168.1.1"   ,   /* Gateway IP */
                      };

// port 80 is default for HTTP
WifiServer server(80);

void parseRxData(String data)
{
}

void setup()
{
  // CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
  pinMode(10, OUTPUT);

  if (!SD.begin(4)) {
    Serial.println("initialization failed!");

    // Error 
    //    while(1);  

    return;
  }

  // connect to AP & start server  
  Wireless.begin(&w_prof, &parseRxData);
  server.begin();

  delay(1000);
}

void loop()
{
  int lineNum = 0;
  int cnt = 0;
  char response[30];
  int p = 0;
  // Listen for incoming clients
  WifiClient client = server.available();
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
          lineNum = 0;
          cnt = 0;
          client.println("HTTP/1.1 200 OK");
          if (p == 0)
            client.println("Content-Type: text/html");
          else if (p == 1)
            client.println("Content-Type: image/png");
          //         else if (p == 2)
          //         client.println("Content-Type: image/jpg");

          client.println("");     
          //client.println(""); 

          myFile = SD.open(response);

          if (myFile) {
            // read from the file until there's nothing else in it:
            while (myFile.available()) {
              client.write(myFile.read());
            } 
            myFile.close();
          } 
          else {
            client.println("Page not found"); 
          }
          break;         
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
          lineNum++;
        } 
        else if (c != '\r'){
          // you've gotten a character on the current line
          if(lineNum == 0){
            if (cnt > 4){
              if ( c == ' '){
                lineNum++;
                response[cnt - 5] = '\0';

                if ((response[cnt - 8] == 'h') && (response[cnt - 7] == 't') && (response[cnt - 6] == 'm'))
                  p = 0;
                else if ((response[cnt - 8] == 'p') && (response[cnt - 7] == 'n') && (response[cnt - 6] == 'g'))
                  p = 1; 
                else if ((response[cnt - 8] == 'j') && (response[cnt - 7] == 'p') && (response[cnt - 6] == 'g'))
                  p = 2;
              }
              else
                response[cnt - 5] = c;
            }
            cnt++;
          }
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




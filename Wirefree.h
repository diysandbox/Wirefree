/*
Wirefree.h - interface class to talk with DIYSandbox Arduino devices 

Copyright (C) 2011 DIYSandbox LLC

Porting for chipKIT boards Copyright (c) 2012 http://electronics.trev.id.au

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

#ifndef _wirefree_h_
#define _wirefree_h_
#ifdef __PIC32MX__			// It's a chipKIT (probably) so...
#include <stdint.h>
#else
#include <avr/pgmspace.h>
#endif
#include <WString.h>

#include "WifiClient.h"
#include "WifiServer.h"

#define MAX_SOCK_NUM 4

// LED Color definitions
#define LED_BLUE        0
#define LED_GREEN       1
#define LED_RED         2
#define LED_CYAN        3
#define LED_MAGENTA     4
#define LED_YELLOW      5
#define LED_WHITE       6
#define LED_OFF         7

#define NORMAL_MODE     0
#define ADHOC_MODE      1
#define AP_MODE         2

typedef struct _WIFI_PROFILE {
	String ssid;
	String security_key;
	String ip;
	String subnet;
	String gateway;
} WIFI_PROFILE;

class Wirefree {
private:
	void initLED();
public:
	void setLED(int color);
  static uint16_t _server_port[MAX_SOCK_NUM];

  void begin(WIFI_PROFILE*, void (*rxDataHndlr)(String data));
  void begin(WIFI_PROFILE*, void (*rxDataHndlr)(String data), uint8_t mode);

  void process();
  uint8_t connected();
  uint8_t socketOpen(String url, String port);

  void sendDeviceID();
  void sendResponse(String data);

  friend class WifiClient;
  friend class WifiServer;
};

extern Wirefree Wireless;

#endif // _wirefree_h_

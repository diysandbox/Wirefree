/*
gs.cpp - HAL driver to talk with Gainspan GS1011 WiFi module

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

#ifndef	_gs_h_
#define	_gs_h_

#ifdef __PIC32MX__		// it's probably a chipKIT board so...
#include <stdint.h>
#else
#include <avr/pgmspace.h>
#endif
#include <WString.h>

typedef uint8_t SOCKET;

class SOCK_STATUS {
public:
  static const uint8_t CLOSED      = 0x00;
  static const uint8_t INIT        = 0x01;
  static const uint8_t LISTEN      = 0x02;
  static const uint8_t ESTABLISHED = 0x03;
  static const uint8_t CLOSE_WAIT  = 0x04;
};

class IPPROTO {
public:
  static const uint8_t TCP  = 6;
};

// command identifiers
// config
#define CMD_DISABLE_ECHO 0
#define CMD_SET_UART_115200 14
// wifi
#define CMD_SET_WPA_PSK  1
#define CMD_SET_SSID     2
#define CMD_DISCONNECT   5
#define CMD_GET_MAC_ADDR 8
//network
#define CMD_DISABLE_DHCP 3
#define CMD_ENABLE_DHCP  4
#define CMD_LISTEN       6
#define CMD_TCP_CONN     7
#define CMD_DNS_LOOKUP   9
#define CMD_CLOSE_CONN   10
#define CMD_NETWORK_SET  11
#define CMD_WIRELESS_MODE 12
#define CMD_ENABLE_DHCPSVR 13

// device operation modes
#define DEV_OP_MODE_COMMAND 0
#define DEV_OP_MODE_DATA    1
#define DEV_OP_MODE_DATA_RX 2

// device wireless connection state
#define DEV_CONN_ST_DISCONNECTED 0
#define DEV_CONN_ST_CONNECTED    1

// connection ID
#define INVALID_CID 255

// wireless connection params
typedef struct _GS_PROFILE {
	String ssid;
	String security_key;
	String ip;
	String subnet;
	String gateway;
} GS_PROFILE;

typedef struct _SOCK_TABLE {
	uint8_t status;
	uint8_t protocol;
	uint16_t port;
	uint8_t cid;
} SOCK_TABLE;

class GSClass {
public:
	uint8_t mode;
	uint8_t init(void (*rx_data_handler)(String data));
	void configure(GS_PROFILE* prof);
	uint8_t connect();
	uint8_t connected();
	void process();
	uint8_t connect_socket(String ip, String port);
	String dns_lookup(String url);
	void send_data(String data);
	void esc_seq_start();
	void esc_seq_stop();
	String get_dev_id();

	void configSocket(SOCKET s, uint8_t protocol, uint16_t port);
	void execSocketCmd(SOCKET s, uint8_t cmd);
	uint8_t readSocketStatus(SOCKET s);
	uint8_t isDataOnSock(SOCKET s);
	uint16_t readData(SOCKET s, uint8_t* buf, uint16_t len);
	uint16_t writeData(SOCKET s, const uint8_t*  buf, uint16_t  len);
	
	static const uint16_t SSIZE = 2048; // Max Tx buffer siz

private:
	String security_key;
	String ssid;
	String local_ip;
	String subnet;
	String gateway;
	uint8_t serv_cid;
	uint8_t client_cid;
	uint8_t dev_mode;
	String ip;
	String port;
	uint8_t connection_state;
	String dev_id;
	String dns_url_ip;
	uint8_t tx_done;

	SOCK_TABLE sock_table[4];
	uint8_t socket_num;
	SOCKET dataOnSock;

	void (*rx_data_handler)(String data);

	String readline(void);
	uint8_t send_cmd(uint8_t cmd);
	uint8_t parse_resp(uint8_t cmd);
	uint8_t send_cmd_w_resp(uint8_t cmd);
	void parse_cmd(String buf);
	void parse_data(String buf);

	void flush();
};

extern GSClass GS;

#endif // _gs_h_

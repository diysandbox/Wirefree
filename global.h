/*
global.h - Global definitions

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

#ifndef	_global_h_
#define _global_h_

#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#define ARETTYPE	size_t
#else
#include "WProgram.h"
#define ARETTYPE	void
#endif

#endif // _global_h_


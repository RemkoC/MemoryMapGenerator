/* 
 * MIT License
 * 
 * Copyright (c) 2017 Remko van Cann
 */

#ifndef #MM PUTS name MM#_H_
#define #MM PUTS name MM#_H_

// Register addresses
#MM LOOP type register MM#
#define C_ADDR_#MM PUTS name %-15s MM# 0x#MM PUTS offset %08x MM#
#MM ENDLOOP MM#


#MM LOOP type register MM#

// Register #MM PUTS name "%s" MM# bitmasks
#MM LOOP type field MM#
#define C_MASK_#MM PUTS name "%-15s" MM# #MM PUTS MASK "0x%08X" MM#
#MM ENDLOOP MM#

#MM ENDLOOP MM#

#endif // #MM PUTS name MM#_H_

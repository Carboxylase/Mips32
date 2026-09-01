# clk -------------------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports clk]
create_clock -name PL_clk -period 10 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# LED -------------------------------------------------------------------
set_property PACKAGE_PIN T22 [get_ports eightBits[0]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[0]]

set_property PACKAGE_PIN T21 [get_ports eightBits[1]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[1]]

set_property PACKAGE_PIN U22 [get_ports eightBits[2]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[2]]

set_property PACKAGE_PIN U21 [get_ports eightBits[3]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[3]]

set_property PACKAGE_PIN V22 [get_ports eightBits[4]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[4]]

set_property PACKAGE_PIN W22 [get_ports eightBits[5]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[5]]

set_property PACKAGE_PIN U19 [get_ports eightBits[6]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[6]]

set_property PACKAGE_PIN U14 [get_ports eightBits[7]]
set_property IOSTANDARD LVCMOS18 [get_ports eightBits[7]]

# Reg Sel -------------------------------------------------------------
set_property PACKAGE_PIN F22 [get_ports regAccessIndex[0]]
set_property IOSTANDARD LVCMOS18 [get_ports regAccessIndex[0]]

set_property PACKAGE_PIN G22 [get_ports regAccessIndex[1]]
set_property IOSTANDARD LVCMOS18 [get_ports regAccessIndex[1]]

set_property PACKAGE_PIN H22 [get_ports regAccessIndex[2]]
set_property IOSTANDARD LVCMOS18 [get_ports regAccessIndex[2]]

set_property PACKAGE_PIN F21 [get_ports regAccessIndex[3]]
set_property IOSTANDARD LVCMOS18 [get_ports regAccessIndex[3]]

set_property PACKAGE_PIN H19 [get_ports regAccessIndex[4]]
set_property IOSTANDARD LVCMOS18 [get_ports regAccessIndex[4]]

# Byte Sel ------------------------------------------------------------
set_property PACKAGE_PIN H18 [get_ports byteNum[0]]
set_property IOSTANDARD LVCMOS18 [get_ports byteNum[0]]

set_property PACKAGE_PIN H17 [get_ports byteNum[1]]
set_property IOSTANDARD LVCMOS18 [get_ports byteNum[1]]      



          
          
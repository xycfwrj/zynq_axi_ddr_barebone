# zynq_axi_ddr_barebone
minimal code to access ps DDR from PL.
generate incremental data in PL and write it to ps DDR address 0x00400000 via s_AXI_HP0 port,

use key[0] to reset axi write module, can be removed.
use key[1] to reset axi write data, can be removed


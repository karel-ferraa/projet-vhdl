ghdl -a -g --std=08 -fexplicit --ieee=synopsys alu.vhd mytb_alu.vhd |& less
ghdl -e -fexplicit --ieee=synopsys --std=08 myALUtestbench
ghdl -r -fexplicit --ieee=synopsys --std=08 myALUtestbench --wave=myALUtestbench.ghw |& less

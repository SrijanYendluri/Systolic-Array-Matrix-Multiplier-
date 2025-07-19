
create_clock -period 10.000 -name mainclk [get_ports clk]



set_property IOSTANDARD LVCMOS33 [get_ports {state_led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
set_property PACKAGE_PIN L1 [get_ports {state_led[0]}]
set_property PACKAGE_PIN P1 [get_ports {state_led[1]}]
set_property PACKAGE_PIN N3 [get_ports {state_led[2]}]
set_property PACKAGE_PIN P3 [get_ports {state_led[3]}]
set_property PACKAGE_PIN U3 [get_ports {state_led[4]}]
set_property PACKAGE_PIN W3 [get_ports {state_led[5]}]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN R2 [get_ports rst]
set_property PACKAGE_PIN B18 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]


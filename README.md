# FPGA-ACC-MAC
## *"A 4x4 8-bit systolic array multiplier on FPGA, verified with a UVM-inspired Python testbench over UART (Basys3)."*

---
This is a personal project that I started this summer feel free to modify or make modifications or add more modules.
---

### Folders 
- matmul_acclerator (Vivado project folder)
  - Run the vivado file to directly open the proj
  - there is Bitstream file already generated that works on BASYS3 only
- Design file
  - All the .sv and constraint files seperately provided 
- Test_Bench.py
  -run this once the FPGA is ready and comports are connected    
- fpga_frimware.py
  - import this into another ptoject to use the fpga for computation
- example_use.py
  - clean example to show you how it works

Since this was a month long project it is only 4X4 matrix and only 8 bits I aim to make it more usefull over time as.  

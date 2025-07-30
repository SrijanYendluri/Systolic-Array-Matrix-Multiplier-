# TinyMat
## *"A 4x4 8-bit systolic array multiplier on FPGA, verified with a UVM-inspired Python testbench over UART (Basys3)."*

---
---

### Folders 
- matmul_acclerator (Vivado project folder)
  - Run the vivado file to directly open the proj
  - there is Bitstream file already generated that works on BASYS3 only
- Design file
  - All the .sv and constraint files seperately provided 
- Test_Bench.py
  - run this once the FPGA is ready and comports are connected    
- fpga_frimware.py
  - import this into another ptoject to use the fpga for computation
- example_use.py
  - clean example to show you how it works

Since this is an active personal project it is only 4X4 matrix and only 8 bits for now I aim to impliment more complex protocols as I learn.  


## Tiny Demo 
https://github.com/user-attachments/assets/ab6f93d4-f7ec-4b46-a643-3ef21457dc1b





## Systollic array UVC
![Drawing 2025-07-30 10 59 49 excalidraw](https://github.com/user-attachments/assets/f1acf7d0-6aad-4292-9a58-dcf4aa1be77d)

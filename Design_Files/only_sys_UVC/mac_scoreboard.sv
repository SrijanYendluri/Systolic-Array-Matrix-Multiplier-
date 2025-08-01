`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 03:23:40 PM
// Design Name: 
// Module Name: mac_scoreboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "uvm_macros.svh"
import uvm_pkg::*;

class mac_scoreboard extends uvm_scoreboard;

`uvm_component_utils(mac_scoreboard)

function new (string name = "mac_scoreboard", uvm_component parent = null);
    super.new(name, parent);
endfunction

mac_packet mac_pkt;

uvm_tlm_analysis_fifo #(mac_packet) scoreboard_expo_fifo;

function void build_phase (uvm_phase phase);

scoreboard_expo_fifo = new("scoreboard_expo_fifo", this);


endfunction


task run_phase (uvm_phase phase);
    forever begin 
      mac_packet mac_pkt;

      scoreboard_expo_fifo.get(mac_pkt);  

      `uvm_info(get_type_name(), $sformatf("Recieved form the monitor %s", mac_pkt.sprint()), UVM_NONE)
          
    $display("===============================================================================================");
    

    end
endtask







endclass

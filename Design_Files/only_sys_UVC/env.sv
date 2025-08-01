`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2025 02:49:24 PM
// Design Name: 
// Module Name: env
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
import uvm_pkg :: *;


class mac_env extends uvm_env;

    `uvm_component_utils(mac_env)

    function new (string name = "mac_env", uvm_component parent = null);
    super.new(name, parent);
    endfunction

    mac_agent mac_agnt;
    mac_scoreboard mac_scb;

    function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    mac_agnt = mac_agent :: type_id ::create("mac_agent", this);
    mac_scb = mac_scoreboard :: type_id ::create("mac_scb", this);
        
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        mac_agnt.mac_mon.mac_analysis_port.connect(mac_scb.scoreboard_expo_fifo.analysis_export);
        
    endfunction

endclass
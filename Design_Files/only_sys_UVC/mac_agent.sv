`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg :: *;


class mac_agent extends uvm_agent;
    `uvm_component_utils(mac_agent)


    mac_packet mac_pkt;
    mac_monitor mac_mon;
    mac_driver mac_driv;

    uvm_sequencer #(mac_packet) mac_sequencer;
    uvm_active_passive_enum is_active;



    extern function new (string name = "mac_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);

endclass : mac_agent
      
      

function mac_agent::new(string name = "mac_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void mac_agent::build_phase(uvm_phase phase);
super.build_phase(phase);
    mac_pkt = mac_packet :: type_id :: create("mac_pkt");
    mac_mon = mac_monitor :: type_id :: create("mac_mon", this);
    mac_driv = mac_driver :: type_id :: create("mac_driv", this);


    mac_sequencer = uvm_sequencer #(mac_packet) :: type_id :: create("mac_sequencer", this);
endfunction : build_phase

function void mac_agent::connect_phase (uvm_phase phase);
    super.connect_phase(phase);

    mac_driv.seq_item_port.connect(mac_sequencer.seq_item_export);
endfunction : connect_phase


`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg :: *;


class mac_monitor extends uvm_monitor;
    
    `uvm_component_utils(mac_monitor)

    mac_packet macpkt, temp_pkt;
    uvm_analysis_port#(mac_packet) mac_analysis_port;
    virtual sc_if scif;

    extern function new (string name = "mac_monitor", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);


endclass : mac_monitor

      
      
      
      

function mac_monitor::new (string name = "mac_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction : new



function void mac_monitor::build_phase (uvm_phase phase);
    super.build_phase(phase);

    mac_analysis_port = new("mac_analysis_port",this);
    macpkt = mac_packet :: type_id :: create("macpkt");
    temp_pkt = mac_packet :: type_id :: create("temp_pkt");

    assert(uvm_config_db#(virtual sc_if)::get(this,"interface","scif",scif)) else 
    begin 
    `uvm_error(get_type_name(), "Interfaces did not init") 
    end

endfunction : build_phase


task mac_monitor::run_phase (uvm_phase phase);
    forever begin 
    @(posedge scif.completed);
    macpkt.st_rst = scif.st_rst;
    macpkt.A = scif.A;
    macpkt.B = scif.B;
    macpkt.completed = scif.completed;
    macpkt.C = scif.C;
    $cast(temp_pkt, macpkt.clone());
    mac_analysis_port.write(temp_pkt);
    #1;
    // `uvm_info(get_type_name(), $sformatf("sent to scoreboard: %0s", macpkt.sprint()), UVM_NONE);
    end
endtask : run_phase
  
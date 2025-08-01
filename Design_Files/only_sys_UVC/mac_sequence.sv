`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
class mac_sequence extends uvm_sequence #(mac_packet);
  `uvm_object_utils(mac_sequence)
  function new(string name = "mac_sequence");
    super.new(name);
  endfunction
  
  
  task body();
    mac_packet mpk;
    `uvm_info(get_type_name(),"Sequence started",UVM_NONE);

    repeat(5) begin 
      `uvm_do_with(mpk, {mpk.st_rst == 0;})
    end   
    
  endtask
    
  
endclass
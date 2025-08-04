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

    repeat(10) begin 
      `uvm_do_with(mpk, {mpk.st_rst == 0;})
    end   
    
  endtask
    
  
endclass









class mac_sequence_verified extends uvm_sequence #(mac_packet);
  `uvm_object_utils(mac_sequence_verified)
  function new(string name = "mac_sequence");
    super.new(name);
  endfunction
  
  
  task body();
    mac_packet mpk;
    `uvm_info(get_type_name(),"Sequence started",UVM_NONE);

    repeat(2) begin 
      `uvm_create(mpk)

      start_item(mpk);
          mpk.st_rst = 0;
          mpk.A[0] = {8'd1, 8'd2, 8'd3, 8'd4};
          mpk.A[1] = {8'd5, 8'd6, 8'd7, 8'd8};
          mpk.A[2] = {8'd9, 8'd10, 8'd11, 8'd12};
          mpk.A[3] = {8'd13, 8'd14, 8'd15, 8'd16};
          mpk.B[0] = {8'd1, 8'd2, 8'd3, 8'd4};
          mpk.B[1] = {8'd5, 8'd6, 8'd7, 8'd8};
          mpk.B[2] = {8'd9, 8'd10, 8'd11, 8'd12};
          mpk.B[3] = {8'd13, 8'd14, 8'd15, 8'd16};
    finish_item(mpk);

    end
  endtask
    
  
endclass
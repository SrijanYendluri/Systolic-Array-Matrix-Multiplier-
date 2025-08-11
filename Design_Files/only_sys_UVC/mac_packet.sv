`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg :: *;

typedef enum {NORMAL, OVERFLOW} VALUES;


class mac_packet extends uvm_sequence_item;

  rand logic st_rst;
  rand logic [31:0] A [0:3];
  rand logic [31:0] B [0:3];
  logic [15:0] C [0:3][0:3];
  logic completed;
  VALUES pkt_type; 
  rand bit [5:0] delay; 
  
  
  static int pkt_number = 0;
  
  function new(string name = "mac_packet");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(mac_packet)


 `uvm_field_int( pkt_number, UVM_DEFAULT)

  `uvm_field_int(st_rst, UVM_DEFAULT)

 
  
  `uvm_field_sarray_int(A, UVM_DEFAULT)

  
  `uvm_field_sarray_int(B, UVM_DEFAULT)
//   `uvm_field_sarray_int(B[1], UVM_DEFAULT || UVM_DEC)
//   `uvm_field_sarray_int(B[2], UVM_DEFAULT || UVM_DEC)
//   `uvm_field_sarray_int(B[3], UVM_DEFAULT || UVM_DEC)
  
  `uvm_field_sarray_int(C[0], UVM_DEFAULT)
  `uvm_field_sarray_int(C[1], UVM_DEFAULT)
  `uvm_field_sarray_int(C[2], UVM_DEFAULT)
  `uvm_field_sarray_int(C[3], UVM_DEFAULT)
//   `uvm_field_sarray_int(C[1], UVM_DEFAULT || UVM_DEC)
//   `uvm_field_sarray_int(C[2], UVM_DEFAULT || UVM_DEC)
//   `uvm_field_sarray_int(C[3], UVM_DEFAULT || UVM_DEC)
  
  `uvm_field_int(completed, UVM_DEFAULT);
  
  `uvm_field_enum(VALUES, pkt_type, UVM_DEFAULT);
  
  `uvm_object_utils_end
    
  
  int a_j;
  int b_j;
  constraint a_values {foreach(A[a_j]) A[a_j] inside {[32'd0:32'h7f_7f_7f_7f]};}
  constraint b_values {foreach(B[b_j]) B[b_j] inside {[32'd0:32'h7f_7f_7f_7f]};}
  
  int a_k;
  int b_k;
  constraint a_values_e {foreach(A[a_k]) A[a_k] inside {[32'h80_80_80_80: 32'hff_ff_ff_ff]};}
  constraint b_values_e {foreach(B[b_k]) B[b_k] inside {[32'h80_80_80_80: 32'hff_ff_ff_ff]};}
  
  function void pre_randomize();

    if (pkt_type == NORMAL)begin 

      a_values.constraint_mode(1);
      b_values.constraint_mode(1);
      a_values_e.constraint_mode(0);
      b_values_e.constraint_mode(0);
      
      
    end else if (pkt_type == OVERFLOW) begin 
      a_values.constraint_mode(0);
      b_values.constraint_mode(0);
      a_values_e.constraint_mode(1);
      b_values_e.constraint_mode(1);
      
    end
  
  
  endfunction
  
    	
  
  function void post_randomize();
//	int i;
//    int j;
   
    
//    foreach(C[i][j]) begin 
    
//      C[i][j] = '0;	
//    end
    
    pkt_number = pkt_number + 1;
  endfunction
  
  
  
  
  
  
  
endclass
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
endfunction : new

mac_packet mac_pkt;

uvm_tlm_analysis_fifo #(mac_packet) scoreboard_expo_fifo;
uvm_analysis_imp#(mac_packet, mac_scoreboard) scoreboard_imp;

function void build_phase (uvm_phase phase);

  scoreboard_expo_fifo = new("scoreboard_expo_fifo", this);
  mac_pkt = mac_packet :: type_id :: create("mac_packet");
  scoreboard_imp = new("scoreboard_imp", this);
endfunction : build_phase

typedef logic [15:0] C4X4 [0:3][0:3];
 C4X4 scb_test;
function automatic C4X4 matrix_mul(
    input logic [31:0] a [0:3],
    input logic [31:0] b [0:3]
);
    logic [7:0] A_mat [0:3][0:3];
    logic [7:0] B_mat [0:3][0:3];
    logic [15:0] C_mat [0:3][0:3];
    int i, j, k;

    // Unpack 32-bit rows into 8-bit elements
    for (i = 0; i < 4; i++) begin
        A_mat[i][0] = a[i][31:24];
        A_mat[i][1] = a[i][23:16];
        A_mat[i][2] = a[i][15:8];
        A_mat[i][3] = a[i][7:0];

        B_mat[i][0] = b[i][31:24];
        B_mat[i][1] = b[i][23:16];
        B_mat[i][2] = b[i][15:8];
        B_mat[i][3] = b[i][7:0];
    end

    // Matrix multiply: C = A * B
    for (i = 0; i < 4; i++) begin
        for (j = 0; j < 4; j++) begin
            C_mat[i][j] = 0;
            for (k = 0; k < 4; k++) begin
                C_mat[i][j] += A_mat[i][k] * B_mat[k][j];
            end
        end
    end

    return C_mat;
endfunction


function bit compare_C_matrix(
  input logic [15:0] C1[0:3][0:3],
  input logic [15:0] C2[0:3][0:3]
);
  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
     
      if (C1[i][j] !== C2[i][j]) return 0;
      
    end
  end
  return 1;
endfunction

// task run_phase (uvm_phase phase);
//     forever begin 
      

//     scoreboard_expo_fifo.get(mac_pkt);

//     $display("checking completed");
//     if(mac_pkt.completed)begin
//       $display("checking completed");
//     scb_test = matrix_mul(mac_pkt.A, mac_pkt.B);
  
//     if(compare_C_matrix(mac_pkt.C, scb_test)) begin
     
//       `uvm_info(get_type_name(), $sformatf("Test passed"),UVM_NONE)
//     end else begin

//      `uvm_error(get_type_name(), $sformatf("Packet: %s", mac_pkt.sprint()))
//           end
//     $display("===============================================================================================");
    
//     end

//     end
// endtask

function void write(input mac_packet packet);

  
 
    if(packet.completed)begin

    scb_test = matrix_mul(packet.A, packet.B);
  
    if(compare_C_matrix(packet.C, scb_test)) begin
     
      `uvm_info(get_type_name(), $sformatf("Test passed"),UVM_NONE)
    end else begin

     `uvm_error(get_type_name(), $sformatf("Not matched Packet: %s", packet.sprint()))
          end
    $display("===============================================================================================");
    
    end else begin 
      `uvm_error(get_type_name(), $sformatf("Completed never went high \n Packet : %0s ",packet.sprint()) )

    end



endfunction : write






endclass

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;





typedef logic [15:0] C4X4 [0:3][0:3];

class mac_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(mac_scoreboard)

    C4X4 scb_test;
    mac_packet mac_pkt, cov_pkt;
    uvm_tlm_analysis_fifo #(mac_packet) scoreboard_expo_fifo;
    uvm_analysis_imp#(mac_packet, mac_scoreboard) scoreboard_imp;

	int failed;
  	int passed;
  	int x,y;
  
  covergroup mux_coverage;
    
    MA0 : coverpoint cov_pkt.A[0] {
      ignore_bins e_th_bit = {[128:255]};
    }
    MA1 : coverpoint  cov_pkt.A[1] {
      ignore_bins e_th_bit = {[128:255]};
    }
    MA2 : coverpoint cov_pkt.A[2]{
      ignore_bins e_th_bit = {[128:255]};
    }
    MA3 : coverpoint  cov_pkt.A[3]{
      ignore_bins e_th_bit = {[128:255]};
    }
    
    MB0 : coverpoint cov_pkt.B[0] {
      ignore_bins e_th_bit = {[128:255]};
    }
    MB1 : coverpoint  cov_pkt.B[1] {
      ignore_bins e_th_bit = {[128:255]};
    }
    MB2 : coverpoint cov_pkt.B[2]{
      ignore_bins e_th_bit = {[128:255]};
    }
    MB3 : coverpoint  cov_pkt.B[3]{
      ignore_bins e_th_bit = {[128:255]};
    }
	
 
    coverpoint cov_pkt.C[0][0] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[0][1] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[0][2] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[0][3] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[1][0] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[1][1] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[1][2] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[1][3] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[2][0] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[2][1] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[2][2] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[2][3] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[3][0] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[3][1] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[3][2] {
      ignore_bins ignore_range = {[64516:65535]};
    }
    coverpoint cov_pkt.C[3][3] {
      ignore_bins ignore_range = {[64516:65535]};
    }
	
  endgroup
    
   
  	
  
    extern function new (string name = "mac_scoreboard", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);

    extern function automatic C4X4 matrix_mul(
    input logic [31:0] a [0:3],
    input logic [31:0] b [0:3]
    );

    extern function bit compare_C_matrix(
    input logic [15:0] C1[0:3][0:3],
    input logic [15:0] C2[0:3][0:3]
    );
    
    // extern task run_phase (uvm_phase phase);
    extern function void write(input mac_packet packet);
    extern function void report_phase (uvm_phase phase);

endclass : mac_scoreboard

      
      
      
      
      
      

function mac_scoreboard::new (string name = "mac_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  	mux_coverage = new;
endfunction : new


function void mac_scoreboard::build_phase (uvm_phase phase);
    super.build_phase(phase);
    scoreboard_expo_fifo = new("scoreboard_expo_fifo", this);
    mac_pkt = mac_packet :: type_id :: create("mac_packet");
  	cov_pkt = mac_packet :: type_id :: create("cov_pkt");
    scoreboard_imp = new("scoreboard_imp", this);
endfunction : build_phase

function automatic C4X4 mac_scoreboard::matrix_mul(
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
endfunction : matrix_mul


function bit mac_scoreboard::compare_C_matrix(
  input logic [15:0] C1[0:3][0:3],
  input logic [15:0] C2[0:3][0:3]
);
  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
     
      if (C1[i][j] !== C2[i][j]) return 0;
      
    end
  end
  return 1;
endfunction : compare_C_matrix


// task mac_scoreboard::run_phase (uvm_phase phase);
//     forever begin 
//         scoreboard_expo_fifo.get(mac_pkt);

//         if(mac_pkt.completed)begin
        
//         scb_test = matrix_mul(mac_pkt.A, mac_pkt.B);

//         if(compare_C_matrix(mac_pkt.C, scb_test)) begin
            
//             `uvm_info(get_type_name(), $sformatf("Test passed"),UVM_NONE)
//         end else begin

//             `uvm_error(get_type_name(), $sformatf("Packet: %s", mac_pkt.sprint()))
//                 end
//         $display("===============================================================================================");

//         end

//     end
// endtask : run_phase


function void mac_scoreboard::write(input mac_packet packet);

    if(packet.completed)begin
      	cov_pkt.copy(packet);
        scb_test = matrix_mul(packet.A, packet.B);

        if(compare_C_matrix(packet.C, scb_test)) begin

//            `uvm_info(get_type_name(), $sformatf("Test passed"),UVM_NONE)
          	mux_coverage.sample();
          	passed++;
            `uvm_info(get_type_name(), $sformatf("curr Coverage value:  %0f", mux_coverage.get_coverage()), UVM_NONE)
        end else begin

            `uvm_error(get_type_name(), $sformatf("Not matched Packet: %s", packet.sprint()))
          failed ++;
        end

//        $display("===============================================================================================");

    end else begin 
        `uvm_error(get_type_name(), $sformatf("Completed never went high \n Packet : %0s ",packet.sprint()) )

    end

endfunction : write
      
      
      
      
      

function void mac_scoreboard :: report_phase (uvm_phase phase);

  `uvm_info(get_type_name(), $sformatf("Number of Faliure trnx: %0d", failed), UVM_NONE)
  `uvm_info(get_type_name(), $sformatf("Number of Successful trnx: %0d", passed), UVM_NONE)
  `uvm_info(get_type_name(), $sformatf("Coverage value:  %0f", mux_coverage.get_coverage()), UVM_NONE)

endfunction : report_phase


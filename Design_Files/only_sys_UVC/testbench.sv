
`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "mac_uvc_pkg.sv"
import mac_uvc_pkg :: *;



class mac_test extends uvm_test;
    `uvm_component_utils(mac_test)

    mac_sequence mac_seq;
    mac_sequence_verified mac_seq_known;
    mac_env env;

    extern function new (string name = "uvm_test", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
endclass : mac_test


function mac_test::new (string name = "uvm_test", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void mac_test::build_phase (uvm_phase phase);
    super.build_phase(phase);

    mac_seq = mac_sequence :: type_id :: create("mac_seq");
    mac_seq_known = mac_sequence_verified :: type_id :: create("mac_seq_known");
    env = mac_env :: type_id :: create("env", this);
endfunction : build_phase


task mac_test::run_phase(uvm_phase phase);
    phase.raise_objection(this, "Raised objection at test");

  while (env.mac_scb.mux_coverage.get_coverage() < 90) begin 

//     mac_seq_known.start(env.mac_agnt.mac_sequencer);
    mac_seq.start(env.mac_agnt.mac_sequencer);
    
  end
   
    #100;

    phase.drop_objection(this, "Dropped objection at test");
endtask : run_phase

function void mac_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction : end_of_elaboration_phase

// module tb_packetchk;
//   mac_packet pkt;
//   initial begin 
//     pkt = new();
//     pkt.pkt_type = OVERFLOW;
//     assert(pkt.randomize);
//     pkt.print();
//   end 
  
// endmodule



module tb_driver();
  
  mac_driver driver;
  sc_if scif();

  initial begin
    scif.clk = 0;
  end
  
  always #5 scif.clk = ~scif.clk;
  
  
  systolic_controller design_dut (
    .clk(scif.clk),
    .st_rst(scif.st_rst),
    .A(scif.A),
    .B(scif.B),
    .C(scif.C),
    .completed(scif.completed)
  );
  
  initial begin 
    
    uvm_config_db#(virtual sc_if)::set(null,"*.interface","scif",scif);
     
    run_test("mac_test");
    
  end
  
endmodule
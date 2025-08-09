`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg :: *;




class mac_driver extends uvm_driver#(mac_packet);
  
    `uvm_component_utils(mac_driver)
    virtual sc_if scif;
    static bit quick_rst = 0;
    uvm_sequencer#(mac_packet) mac_sequencer; 



    extern function new (string name = "mac_driver", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task drive_dut(mac_packet mp);
    extern task run_phase(uvm_phase phase);

endclass : mac_driver




//=========================================================================================
function mac_driver::new (string name = "mac_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction : new


//================================================================================
function void mac_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build PHASE", UVM_NONE);
    //     mac_sequrencer = uvm_sequencer#(mac_packet) :: type_id :: create("mac_sequencer", this);

    assert(uvm_config_db#(virtual sc_if) :: get(this,"interface","scif", scif)) else begin 
        `uvm_error(get_type_name(), $sformatf("Failed to connect to interface %0p",this));
    end

endfunction : build_phase

//================================================================================
task mac_driver::drive_dut(mac_packet mp); 
	#mp.delay;
    @(posedge scif.clk);
//    `uvm_info(get_type_name(), "Driving DUT", UVM_NONE);
    scif.st_rst <= mp.st_rst;
    scif.A <= mp.A;
    scif.B <= mp.B;
    wait(scif.completed);
    scif.st_rst <= 1'b1;
    @(posedge scif.clk);

//    $display("===============================================================================================");
    // `uvm_info(get_type_name(), $sformatf("trns %s", mp.sprint()),UVM_NONE);

endtask : drive_dut

//===================================================================================
task mac_driver::run_phase(uvm_phase phase);

    // `uvm_error(get_type_name(),"ResetPhase start")
    phase.raise_objection(this);

        @ (posedge scif.clk);
        scif.st_rst <= 1;
        repeat(3)
            @ (negedge scif.clk);

    phase.drop_objection(this);

    forever begin

        // `uvm_error(get_type_name(),"ResetPhase ended")
        mac_packet mp;
        mp = mac_packet :: type_id:: create("mp");
        seq_item_port.get_next_item(mp);

        // `uvm_error(get_type_name(),"Sequenvcer started")

        drive_dut(mp);

        seq_item_port.item_done();
    end

endtask : run_phase

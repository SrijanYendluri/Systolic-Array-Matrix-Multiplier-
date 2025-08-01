


class mac_monitor extends uvm_monitor;
  `uvm_component_utils(mac_monitor)
  
  function new (string name = "mac_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  mac_packet macpkt;
  uvm_analysis_port#(mac_packet) mac_analysis_port;
  virtual sc_if scif;

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    mac_analysis_port = new("mac_analysis_port",this);
    macpkt = mac_packet :: type_id :: create("macpkt");

    assert(uvm_config_db#(virtual sc_if)::get(this,"interface","scif",scif)) else 
    begin 
      `uvm_error(get_type_name(), "Interfaces did not init") 
        end

  endfunction

  task run_phase (uvm_phase phase);
    forever begin 

        wait(scif.st_rst);
        macpkt.A <= scif.A;
        macpkt.B <= scif.B;
        wait(scif.completed);
        macpkt.C <= scif.C;

        mac_analysis_port.write(macpkt);
      `uvm_info(get_type_name(), $sformatf("sent to scoreboard: %0s", macpkt.sprint()), UVM_NONE);
    end
  endtask 
  
  
  
endclass
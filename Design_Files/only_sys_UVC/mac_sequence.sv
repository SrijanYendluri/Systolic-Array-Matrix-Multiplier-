class mac_sequence extends uvm_sequence #(mac_packet);
  `uvm_object_utils(mac_sequence)
  function new(string name = "mac_sequence");
    super.new(name);
  endfunction
  
  
  task body();
    mac_packet mpk;
    `uvm_info(get_type_name(),"Sequence started",UVM_NONE);
    repeat(5) begin 
      `uvm_do(mpk)
    end   
    
  endtask
    
  
endclass
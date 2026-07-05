class wr_agent extends uvm_agent;
  `uvm_component_utils(wr_agent)

  wr_sequencer sqr;
  wr_driver    drv;
  wr_monitor   mon;

  function new(string name = "wr_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Always build the monitor
    mon = wr_monitor::type_id::create("mon", this);
    
    // Build driver and sequencer only if agent is ACTIVE
    if (get_is_active() == UVM_ACTIVE) begin
      sqr = wr_sequencer::type_id::create("sqr", this);
      drv = wr_driver::type_id::create("drv", this);
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
endclass

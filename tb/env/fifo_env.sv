class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  // Components
  wr_agent       w_agent;
  rd_agent       r_agent;
  fifo_scoreboard scb;
  fifo_coverage   cov;

  function new(string name = "fifo_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    w_agent = wr_agent::type_id::create("w_agent", this);
    r_agent = rd_agent::type_id::create("r_agent", this);
    scb     = fifo_scoreboard::type_id::create("scb", this);
    cov     = fifo_coverage::type_id::create("cov", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Wire monitors to the scoreboard
    w_agent.mon.ap.connect(scb.ap_wr);
    r_agent.mon.ap.connect(scb.ap_rd);
  endfunction

endclass

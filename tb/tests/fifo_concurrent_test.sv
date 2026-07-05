class fifo_concurrent_test extends uvm_test;
  `uvm_component_utils(fifo_concurrent_test)

  fifo_env env;

  function new(string name = "fifo_concurrent_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    wr_burst_seq w_seq;
    rd_burst_seq r_seq;

    phase.raise_objection(this);

    w_seq = wr_burst_seq::type_id::create("w_seq");
    r_seq = rd_burst_seq::type_id::create("r_seq");

    // Wait for reset to finish before starting traffic
    #50ns; 

    `uvm_info("TEST", "Starting Concurrent Write and Read Sequences...", UVM_LOW)
    
    // Run them in parallel to stress the synchronizers
    fork
      w_seq.start(env.w_agent.sqr);
      
      // Delay the read slightly to allow data to cross the domains
      begin
        #100ns;
        r_seq.start(env.r_agent.sqr);
      end
    join

    // Allow time for the final pipeline stages to settle
    #200ns;

    phase.drop_objection(this);
  endtask
endclass

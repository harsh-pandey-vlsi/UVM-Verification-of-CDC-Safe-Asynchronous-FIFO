class fifo_coverage extends uvm_component;
  `uvm_component_utils(fifo_coverage)

  virtual wr_if wr_vif;
  virtual rd_if rd_vif;

  // Covergroup for Write Domain states (Clock event removed)
  covergroup wr_cg;
    option.per_instance = 1;
    
    cp_wr_en: coverpoint wr_vif.wr_en;
    cp_wfull: coverpoint wr_vif.wfull;
    
    cx_wr_full: cross cp_wr_en, cp_wfull {
      ignore_bins ignore_normal = binsof(cp_wfull) intersect {0};
    }
  endgroup

  // Covergroup for Read Domain states (Clock event removed)
  covergroup rd_cg;
    option.per_instance = 1;
    
    cp_rd_en: coverpoint rd_vif.rd_en;
    cp_rempty: coverpoint rd_vif.rempty;
    
    cx_rd_empty: cross cp_rd_en, cp_rempty {
      ignore_bins ignore_normal = binsof(cp_rempty) intersect {0};
    }
  endgroup

  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    // Embedded covergroups MUST be instantiated in the new() function
    wr_cg = new();
    rd_cg = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wr_if)::get(this, "", "wr_vif", wr_vif)) 
      `uvm_fatal("NOVIF", "No wr_if found for coverage")
    if (!uvm_config_db#(virtual rd_if)::get(this, "", "rd_vif", rd_vif)) 
      `uvm_fatal("NOVIF", "No rd_if found for coverage")
  endfunction

  virtual task run_phase(uvm_phase phase);
    fork
      // Explicitly sample Write domain on every write clock edge
      forever begin
        @(posedge wr_vif.wr_clk);
        wr_cg.sample();
      end
      
      // Explicitly sample Read domain on every read clock edge
      forever begin
        @(posedge rd_vif.rd_clk);
        rd_cg.sample();
      end
    join
  endtask
    
    virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    `uvm_info("COV_REPORT", "========================================", UVM_NONE)
    `uvm_info("COV_REPORT", "       FUNCTIONAL COVERAGE SUMMARY      ", UVM_NONE)
    `uvm_info("COV_REPORT", "========================================", UVM_NONE)
    
    // Query the covergroups for their specific coverage percentages
    `uvm_info("COV_REPORT", $sformatf("Write Domain Coverage (wr_cg): %0.2f%%", wr_cg.get_coverage()), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("Read Domain Coverage (rd_cg):  %0.2f%%", rd_cg.get_coverage()), UVM_NONE)
    
    `uvm_info("COV_REPORT", "========================================", UVM_NONE)
  endfunction

endclass

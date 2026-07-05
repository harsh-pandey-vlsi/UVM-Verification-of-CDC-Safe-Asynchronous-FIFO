class wr_monitor extends uvm_monitor;
  `uvm_component_utils(wr_monitor)

  virtual wr_if vif;
  uvm_analysis_port #(wr_seq_item) ap;

  function new(string name = "wr_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wr_if)::get(this, "", "wr_vif", vif)) begin
      `uvm_fatal("NOVIF", "Failed to get virtual interface for Write Monitor")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    wr_seq_item item;
    
    forever begin
      @(vif.mon_cb);
      
      // Capture only valid write transactions
      if (vif.mon_cb.wr_en && !vif.mon_cb.wfull) begin
        item = wr_seq_item::type_id::create("item");
        item.wr_en = vif.mon_cb.wr_en;
        item.wdata = vif.mon_cb.wdata;
        item.wfull = vif.mon_cb.wfull;
        ap.write(item); // Broadcast to Scoreboard
      end
    end
  endtask
endclass

class rd_monitor extends uvm_monitor;
  `uvm_component_utils(rd_monitor)

  virtual rd_if vif;
  uvm_analysis_port #(rd_seq_item) ap;

  function new(string name = "rd_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_if)::get(this, "", "rd_vif", vif)) begin
      `uvm_fatal("NOVIF", "Failed to get virtual interface for Read Monitor")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    rd_seq_item item;
    
    forever begin
      @(vif.mon_cb);
      
      // Capture only valid read transactions
      if (vif.mon_cb.rd_en && !vif.mon_cb.rempty) begin
        item = rd_seq_item::type_id::create("item");
        item.rd_en  = vif.mon_cb.rd_en;
        item.rdata  = vif.mon_cb.rdata;
        item.rempty = vif.mon_cb.rempty;
        ap.write(item); // Broadcast to Scoreboard
      end
    end
  endtask
endclass

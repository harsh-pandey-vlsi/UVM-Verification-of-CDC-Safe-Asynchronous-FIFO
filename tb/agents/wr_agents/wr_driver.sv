class wr_driver extends uvm_driver #(wr_seq_item);
  `uvm_component_utils(wr_driver)

  virtual wr_if vif;

  function new(string name = "wr_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wr_if)::get(this, "", "wr_vif", vif)) begin
      `uvm_fatal("NOVIF", "Failed to get virtual interface for Write Driver")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    // Initialize signals
    vif.wr_en <= 0;
    vif.wdata <= 0;
    
    // Wait for reset to complete
    wait(vif.wr_rst_n === 1'b1);

    forever begin
      seq_item_port.get_next_item(req);
      
      // Wait for the next clock edge via clocking block
      @(vif.cb);
      
      // Reactive drive: Only drive wr_en if the sequence requests it AND we are not full
      if (req.wr_en && !vif.cb.wfull) begin
        vif.cb.wr_en <= 1'b1;
        vif.cb.wdata <= req.wdata;
      end else begin
        vif.cb.wr_en <= 1'b0;
        vif.cb.wdata <= 8'h00;
      end
      
      seq_item_port.item_done();
    end
  endtask
endclass

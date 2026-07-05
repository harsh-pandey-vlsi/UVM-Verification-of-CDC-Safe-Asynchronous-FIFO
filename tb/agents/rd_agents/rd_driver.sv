class rd_driver extends uvm_driver #(rd_seq_item);
  `uvm_component_utils(rd_driver)

  virtual rd_if vif;

  function new(string name = "rd_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_if)::get(this, "", "rd_vif", vif)) begin
      `uvm_fatal("NOVIF", "Failed to get virtual interface for Read Driver")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    vif.rd_en <= 0;
    
    wait(vif.rd_rst_n === 1'b1);

    forever begin
      seq_item_port.get_next_item(req);
      
      @(vif.cb);
      // Reactive drive: Only drive rd_en if the sequence requests it AND we are not empty
      if (req.rd_en && !vif.cb.rempty) begin
        vif.cb.rd_en <= 1'b1;
      end else begin
        vif.cb.rd_en <= 1'b0;
      end
      
      seq_item_port.item_done();
    end
  endtask
endclass

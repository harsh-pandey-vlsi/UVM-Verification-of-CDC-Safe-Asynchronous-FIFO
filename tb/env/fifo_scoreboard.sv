// Macro to create unique Analysis Imp ports for Write and Read streams
`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  // Incoming ports from Monitors
  uvm_analysis_imp_wr #(wr_seq_item, fifo_scoreboard) ap_wr;
  uvm_analysis_imp_rd #(rd_seq_item, fifo_scoreboard) ap_rd;

  // Reference Model: SystemVerilog Queue
  bit [7:0] expected_queue[$];

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    ap_wr = new("ap_wr", this);
    ap_rd = new("ap_rd", this);
  endfunction

  // Write function triggered by the Write Monitor
  virtual function void write_wr(wr_seq_item item);
    if (item.wr_en && !item.wfull) begin
      expected_queue.push_back(item.wdata);
      `uvm_info("SCB_WR", $sformatf("Pushed Data: %0h | Q_Size: %0d", item.wdata, expected_queue.size()), UVM_MEDIUM)
    end
  endfunction

  // Write function triggered by the Read Monitor
  virtual function void write_rd(rd_seq_item item);
    bit [7:0] exp_data;

    if (item.rd_en && !item.rempty) begin
      if (expected_queue.size() == 0) begin
        `uvm_error("SCB_ERR", "Read performed but expected queue is empty!")
      end else begin
        exp_data = expected_queue.pop_front();
        if (exp_data !== item.rdata) begin
          `uvm_error("SCB_FAIL", $sformatf("Data Mismatch! Expected: %0h, Actual: %0h", exp_data, item.rdata))
        end else begin
          `uvm_info("SCB_PASS", $sformatf("Matched Data: %0h", exp_data), UVM_HIGH)
        end
      end
    end
  endfunction
  
  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (expected_queue.size() > 0) begin
      `uvm_warning("SCB_WARN", $sformatf("Test ended with %0d items left in FIFO!", expected_queue.size()))
    end
  endfunction
endclass

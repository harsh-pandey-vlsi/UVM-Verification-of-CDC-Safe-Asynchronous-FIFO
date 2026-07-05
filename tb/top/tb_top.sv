module tb_top;
  import uvm_pkg::*;
  import fifo_test_pkg::*;

  // Physical Signals
  logic wr_clk, wr_rst_n;
  logic rd_clk, rd_rst_n;

  // 1. Generate Asynchronous Clocks
  initial begin
    wr_clk = 0;
    forever #5ns wr_clk = ~wr_clk; // 10ns period (100 MHz)
  end

  initial begin
    rd_clk = 0;
    forever #11.5ns rd_clk = ~rd_clk; // 23ns period (~43 MHz)
  end

  // 2. Generate Resets
  initial begin
    wr_rst_n = 0;
    rd_rst_n = 0;
    #25ns;
    wr_rst_n = 1;
    rd_rst_n = 1;
  end

  // 3. Instantiate Interfaces
  wr_if w_if(.wr_clk(wr_clk), .wr_rst_n(wr_rst_n));
  rd_if r_if(.rd_clk(rd_clk), .rd_rst_n(rd_rst_n));

  // 4. Instantiate DUT
  async_fifo #(
    .DSIZE(8),
    .ASIZE(4)
  ) dut (
    .wr_clk(wr_clk),
    .wr_rst_n(wr_rst_n),
    .wr_en(w_if.wr_en),
    .wdata(w_if.wdata),
    .wfull(w_if.wfull),
    
    .rd_clk(rd_clk),
    .rd_rst_n(rd_rst_n),
    .rd_en(r_if.rd_en),
    .rdata(r_if.rdata),
    .rempty(r_if.rempty)
  );

  // 5. Connect UVM Virtual Interfaces & Start Simulation
  initial begin
    // Pass interfaces to the UVM configuration database
    uvm_config_db#(virtual wr_if)::set(null, "uvm_test_top.*", "wr_vif", w_if);
    uvm_config_db#(virtual rd_if)::set(null, "uvm_test_top.*", "rd_vif", r_if);

    // Start the test (matches the class name in fifo_concurrent_test.sv)
    run_test("fifo_concurrent_test");
  end

  // Optional: Dump waveforms for EDA Playground (EPWave)
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end

endmodule

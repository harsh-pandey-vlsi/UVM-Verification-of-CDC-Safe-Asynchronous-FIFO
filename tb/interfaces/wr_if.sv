interface wr_if (
  input logic wr_clk,
  input logic wr_rst_n
);
  logic       wr_en;
  logic [7:0] wdata;
  logic       wfull;

  // Driver Clocking Block
  clocking cb @(posedge wr_clk);
    default input #1step output #1ns;
    output wr_en;
    output wdata;
    input  wfull;
  endclocking

  // Monitor Clocking Block
  clocking mon_cb @(posedge wr_clk);
    default input #1step output #1ns;
    input wr_en;
    input wdata;
    input wfull;
  endclocking

  // --- SystemVerilog Assertions (SVA) ---
  
  // 1. Never write when full (Overflow protection)
  property p_no_overflow;
    @(posedge wr_clk) disable iff (!wr_rst_n)
    wfull |-> !wr_en;
  endproperty
  assert property (p_no_overflow) 
    else $error("SVA ERROR: Write attempted while FIFO is FULL!");

  // 2. Control signals should not be unknown (X)
  property p_no_x_control;
    @(posedge wr_clk) disable iff (!wr_rst_n)
    !$isunknown(wr_en);
  endproperty
  assert property (p_no_x_control) 
    else $error("SVA ERROR: wr_en is unknown (X)!");

endinterface

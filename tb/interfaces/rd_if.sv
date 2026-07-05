interface rd_if (
  input logic rd_clk,
  input logic rd_rst_n
);
  logic       rd_en;
  logic [7:0] rdata;
  logic       rempty;

  // Driver Clocking Block
  clocking cb @(posedge rd_clk);
    default input #1step output #1ns;
    output rd_en;
    input  rdata;
    input  rempty;
  endclocking

  // Monitor Clocking Block
  clocking mon_cb @(posedge rd_clk);
    default input #1step output #1ns;
    input rd_en;
    input rdata;
    input rempty;
  endclocking

  // --- SystemVerilog Assertions (SVA) ---
  
  // 1. Never read when empty (Underflow protection)
  property p_no_underflow;
    @(posedge rd_clk) disable iff (!rd_rst_n)
    rempty |-> !rd_en;
  endproperty
  assert property (p_no_underflow) 
    else $error("SVA ERROR: Read attempted while FIFO is EMPTY!");

endinterface

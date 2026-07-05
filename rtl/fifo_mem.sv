module fifo_mem #(
  parameter DSIZE = 8,
  parameter ASIZE = 4
) (
  input  logic             wr_clk,
  input  logic             wr_en,
  input  logic             wfull,
  input  logic [ASIZE-1:0] waddr,
  input  logic [ASIZE-1:0] raddr,
  input  logic [DSIZE-1:0] wdata,
  output logic [DSIZE-1:0] rdata
);

  // Memory array
  localparam DEPTH = 1 << ASIZE;
  logic [DSIZE-1:0] mem [0:DEPTH-1];

  // Write operation
  always_ff @(posedge wr_clk) begin
    if (wr_en && !wfull) begin
      mem[waddr] <= wdata;
    end
  end

  // Read operation (Continuous assignment for First-Word Fall-Through behavior)
  assign rdata = mem[raddr];

endmodule

module rptr_empty #(
  parameter ASIZE = 4
) (
  input  logic             rd_clk,
  input  logic             rd_rst_n,
  input  logic             rd_en,
  input  logic [ASIZE:0]   rq2_wgptr,
  output logic             rempty,
  output logic [ASIZE-1:0] raddr,
  output logic [ASIZE:0]   rgptr
);

  logic [ASIZE:0] rbin, rbnext, rgnext;
  logic rempty_val;

  always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
      rbin  <= 0;
      rgptr <= 0;
    end else begin
      rbin  <= rbnext;
      rgptr <= rgnext;
    end
  end

  // Memory read-address pointer (binary)
  assign raddr = rbin[ASIZE-1:0];

  // Next-state logic
  assign rbnext = rbin + (rd_en & ~rempty);
  assign rgnext = (rbnext >> 1) ^ rbnext; // Binary to Gray

  // Empty condition: True if the Gray read pointer exactly matches 
  // the synchronized Gray write pointer.
  assign rempty_val = (rgnext == rq2_wgptr);

  always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) rempty <= 1'b1; // FIFO is empty on reset
    else           rempty <= rempty_val;
  end
endmodule

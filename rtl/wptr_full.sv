module wptr_full #(
  parameter ASIZE = 4
) (
  input  logic             wr_clk,
  input  logic             wr_rst_n,
  input  logic             wr_en,
  input  logic [ASIZE:0]   wq2_rgptr,
  output logic             wfull,
  output logic [ASIZE-1:0] waddr,
  output logic [ASIZE:0]   wgptr
);

  logic [ASIZE:0] wbin, wbnext, wgnext;
  logic wfull_val;

  // Gray code conversion and pointer logic
  always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
      wbin  <= 0;
      wgptr <= 0;
    end else begin
      wbin  <= wbnext;
      wgptr <= wgnext;
    end
  end

  // Memory write-address pointer (binary)
  assign waddr = wbin[ASIZE-1:0];

  // Next-state logic
  assign wbnext = wbin + (wr_en & ~wfull);
  assign wgnext = (wbnext >> 1) ^ wbnext; // Binary to Gray

  // Full condition: 
  // True if the Gray write pointer matches the synchronized Gray read pointer,
  // EXCEPT for the top two MSBs which must be inverted.
  assign wfull_val = (wgnext == {~wq2_rgptr[ASIZE:ASIZE-1], wq2_rgptr[ASIZE-2:0]});

  always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) wfull <= 1'b0;
    else           wfull <= wfull_val;
  end
endmodule

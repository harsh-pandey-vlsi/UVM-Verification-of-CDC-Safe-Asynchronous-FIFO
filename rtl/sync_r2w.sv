module sync_r2w #(
  parameter ASIZE = 4
) (
  input  logic             wr_clk,
  input  logic             wr_rst_n,
  input  logic [ASIZE:0]   rgptr,
  output logic [ASIZE:0]   wq2_rgptr
);

  logic [ASIZE:0] wq1_rgptr;

  always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
      wq1_rgptr <= 0;
      wq2_rgptr <= 0;
    end else begin
      wq1_rgptr <= rgptr;
      wq2_rgptr <= wq1_rgptr;
    end
  end
endmodule

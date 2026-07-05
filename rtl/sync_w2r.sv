module sync_w2r #(
  parameter ASIZE = 4
) (
  input  logic             rd_clk,
  input  logic             rd_rst_n,
  input  logic [ASIZE:0]   wgptr,
  output logic [ASIZE:0]   rq2_wgptr
);

  logic [ASIZE:0] rq1_wgptr;

  always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
      rq1_wgptr <= 0;
      rq2_wgptr <= 0;
    end else begin
      rq1_wgptr <= wgptr;
      rq2_wgptr <= rq1_wgptr;
    end
  end
endmodule

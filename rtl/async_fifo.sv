module async_fifo #(
  parameter DSIZE = 8,
  parameter ASIZE = 4
) (
  // Write Domain
  input  logic             wr_clk,
  input  logic             wr_rst_n,
  input  logic             wr_en,
  input  logic [DSIZE-1:0] wdata,
  output logic             wfull,
  
  // Read Domain
  input  logic             rd_clk,
  input  logic             rd_rst_n,
  input  logic             rd_en,
  output logic [DSIZE-1:0] rdata,
  output logic             rempty
);

  logic [ASIZE-1:0] waddr, raddr;
  logic [ASIZE:0]   wgptr, rgptr, wq2_rgptr, rq2_wgptr;

  // Dual-Port RAM
  fifo_mem #(DSIZE, ASIZE) u_mem (
    .wr_clk(wr_clk),
    .wr_en(wr_en),
    .wfull(wfull),
    .waddr(waddr),
    .raddr(raddr),
    .wdata(wdata),
    .rdata(rdata)
  );

  // Sync Read Pointer to Write Domain
  sync_r2w #(ASIZE) u_sync_r2w (
    .wr_clk(wr_clk),
    .wr_rst_n(wr_rst_n),
    .rgptr(rgptr),
    .wq2_rgptr(wq2_rgptr)
  );

  // Sync Write Pointer to Read Domain
  sync_w2r #(ASIZE) u_sync_w2r (
    .rd_clk(rd_clk),
    .rd_rst_n(rd_rst_n),
    .wgptr(wgptr),
    .rq2_wgptr(rq2_wgptr)
  );

  // Write Pointer & Full Logic
  wptr_full #(ASIZE) u_wptr_full (
    .wr_clk(wr_clk),
    .wr_rst_n(wr_rst_n),
    .wr_en(wr_en),
    .wq2_rgptr(wq2_rgptr),
    .wfull(wfull),
    .waddr(waddr),
    .wgptr(wgptr)
  );

  // Read Pointer & Empty Logic
  rptr_empty #(ASIZE) u_rptr_empty (
    .rd_clk(rd_clk),
    .rd_rst_n(rd_rst_n),
    .rd_en(rd_en),
    .rq2_wgptr(rq2_wgptr),
    .rempty(rempty),
    .raddr(raddr),
    .rgptr(rgptr)
  );

endmodule

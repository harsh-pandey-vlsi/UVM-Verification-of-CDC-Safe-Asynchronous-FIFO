package fifo_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // 1. Sequence Items
  `include "wr_seq_item.sv"
  `include "rd_seq_item.sv"

  // 2. Agents
  `include "wr_sequencer.sv"
  `include "wr_driver.sv"
  `include "wr_monitor.sv"
  `include "wr_agent.sv"

  `include "rd_sequencer.sv"
  `include "rd_driver.sv"
  `include "rd_monitor.sv"
  `include "rd_agent.sv"

  // 3. Env Components
  `include "fifo_scoreboard.sv"
  `include "fifo_coverage.sv"
  `include "fifo_env.sv"

  // 4. Sequences and Tests
  `include "fifo_test_seqs.sv"
  `include "fifo_concurrent_test.sv"

endpackage

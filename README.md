# UVM Verification of CDC-Safe Asynchronous FIFO

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)
![UVM](https://img.shields.io/badge/Framework-UVM_1.2-green.svg)
![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)

## 📌 About
This repository features a complete UVM verification environment for a CDC-safe Asynchronous FIFO. Built in SystemVerilog using the Cummings architecture, the project includes decoupled asynchronous Read/Write agents, a transaction-level scoreboard, concurrent SVAs for protocol checking, and a comprehensive functional coverage model achieving 100%.

## 🏗️ Hardware Architecture (DUT)
The Design Under Test (DUT) is a robust Asynchronous FIFO designed to safely transfer data between two independent, asynchronous clock domains. 
* **Cummings Architecture:** Utilizes Gray code pointers and two-stage flip-flop synchronizers to mitigate metastability.
* **Dual-Port RAM:** First-Word Fall-Through (FWFT) memory payload.
* **Full/Empty Logic:** Computes status flags safely by comparing synchronized Gray-coded pointers.
* **Synthesizable RTL:** The core design is written in standard Verilog-2001, making it fully synthesizable in open-source tools like Yosys.

## 🧪 UVM Testbench Architecture
The verification environment is architected to mirror the physical isolation of the two clock domains:

* **Write Agent (Active):** Operates entirely on `wr_clk` (100 MHz). Contains a reactive driver that respects the `wfull` flag to prevent protocol violations.
* **Read Agent (Active):** Operates entirely on `rd_clk` (~43 MHz). Contains a reactive driver that respects the `rempty` flag.
* **Scoreboard:** A transaction-level checker that uses a SystemVerilog `queue` as a reference model. It receives broadcasted transactions from both monitors via UVM Analysis Ports.
* **SystemVerilog Assertions (SVA):** Bound to the physical interfaces to catch hardware-level overflow and underflow violations instantly.
* **Coverage Collector:** Extracts functional cross-coverage of FIFO states (e.g., attempting to write when full, or read when empty).

## 📁 Directory Structure

```text
async-fifo-uvm/
├── rtl/                            # Design files (Verilog-2001 for synthesis)
│   ├── async_fifo.v                # Top-level DUT
│   ├── fifo_mem.v                  # Dual-port RAM
│   ├── sync_r2w.v                  # Read-ptr to Write-domain synchronizer
│   ├── sync_w2r.v                  # Write-ptr to Read-domain synchronizer
│   ├── rptr_empty.v                # Read pointer and empty logic
│   └── wptr_full.v                 # Write pointer and full logic
├── tb/                             # UVM Testbench files (SystemVerilog)
│   ├── interfaces/
│   │   ├── wr_if.sv                # Write domain interface + SVA
│   │   └── rd_if.sv                # Read domain interface + SVA
│   ├── agents/
│   │   ├── wr_agent/               # Write Sequencer, Driver, Monitor
│   │   └── rd_agent/               # Read Sequencer, Driver, Monitor
│   ├── env/
│   │   ├── fifo_scoreboard.sv      # Transaction-level checking
│   │   ├── fifo_coverage.sv        # Covergroups for FIFO states
│   │   └── fifo_env.sv             # Top-level UVM environment
│   ├── sequences/
│   │   └── fifo_test_seqs.sv       # Burst and concurrent traffic generation
│   ├── tests/
│   │   └── fifo_concurrent_test.sv # Main test stressing CDC crossing
│   └── top/
│       ├── fifo_test_pkg.sv        # UVM package compilation
│       └── tb_top.sv               # Hardware-to-Software bridge, clocks, reset
└── README.md

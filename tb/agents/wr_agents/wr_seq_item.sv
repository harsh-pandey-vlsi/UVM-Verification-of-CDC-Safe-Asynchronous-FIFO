import uvm_pkg::*;
`include "uvm_macros.svh"

class wr_seq_item extends uvm_sequence_item;
  
  // Randomize the inputs
  rand bit       wr_en;
  rand bit [7:0] wdata;
  
  // DUT outputs (captured by monitor, not randomized)
  bit wfull;

  // Factory Registration
  `uvm_object_utils_begin(wr_seq_item)
    `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(wfull, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "wr_seq_item");
    super.new(name);
  endfunction

  // Constraint to make writes happen 70% of the time by default
  constraint c_wr_en {
    wr_en dist {1 := 70, 0 := 30};
  }

endclass

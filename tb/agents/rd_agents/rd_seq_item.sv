import uvm_pkg::*;
`include "uvm_macros.svh"

class rd_seq_item extends uvm_sequence_item;
  
  // Randomize the control
  rand bit rd_en;
  
  // DUT outputs (captured by monitor)
  bit [7:0] rdata;
  bit       rempty;

  // Factory Registration
  `uvm_object_utils_begin(rd_seq_item)
    `uvm_field_int(rd_en,  UVM_ALL_ON)
    `uvm_field_int(rdata,  UVM_ALL_ON)
    `uvm_field_int(rempty, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "rd_seq_item");
    super.new(name);
  endfunction

  // Constraint to make reads happen 70% of the time by default
  constraint c_rd_en {
    rd_en dist {1 := 70, 0 := 30};
  }

endclass

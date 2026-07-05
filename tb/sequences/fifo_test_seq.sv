// --- Write Sequence ---
class wr_burst_seq extends uvm_sequence #(wr_seq_item);
  `uvm_object_utils(wr_burst_seq)

  int num_writes = 20; // Default burst size

  function new(string name = "wr_burst_seq");
    super.new(name);
  endfunction

  virtual task body();
    repeat(num_writes) begin
      req = wr_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize() with { wr_en == 1; }) begin
        `uvm_error("SEQ_ERR", "Randomization failed for Write Sequence")
      end
      finish_item(req);
    end
    
    // Idle cycle at the end
    req = wr_seq_item::type_id::create("req");
    start_item(req);
    // Added safety check here
    if (!req.randomize() with { wr_en == 0; }) begin
      `uvm_error("SEQ_ERR", "Idle Randomization failed for Write Sequence")
    end
    finish_item(req);
  endtask
endclass

// --- Read Sequence ---
class rd_burst_seq extends uvm_sequence #(rd_seq_item);
  `uvm_object_utils(rd_burst_seq)

  int num_reads = 20;

  function new(string name = "rd_burst_seq");
    super.new(name);
  endfunction

  virtual task body();
    repeat(num_reads) begin
      req = rd_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize() with { rd_en == 1; }) begin
        `uvm_error("SEQ_ERR", "Randomization failed for Read Sequence")
      end
      finish_item(req);
    end
    
    // Idle cycle at the end
    req = rd_seq_item::type_id::create("req");
    start_item(req);
    // Added safety check here
    if (!req.randomize() with { rd_en == 0; }) begin
      `uvm_error("SEQ_ERR", "Idle Randomization failed for Read Sequence")
    end
    finish_item(req);
  endtask
endclass

//
// Template for UVM-compliant testcase

`ifndef TEST01__SV
`define TEST01__SV
class sequence_3 extends base_sequence;
  `uvm_object_utils(sequence_3)
  `uvm_add_to_seq_lib(sequence_3,eth_sequencer_sequence_library)

  function new(string name = "seq_3");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    $display("inside sequence_3" );
    repeat(100) begin
          `uvm_do_with(req, { dst==7; src==7; payload == 'hdeadbeef; } )
        #500; //Dummy delay added here for test run
    end
  endtask
endclass

typedef class environment_env;

class test01 extends uvm_test;

  `uvm_component_utils(test01)
  environment_env env;
  uvm_sequence_library_cfg seq_lib_cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment_env::type_id::create("env", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.*.configure_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.*.main_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.main_phase", "default_sequence", sequence_3::get_type());

    

  endfunction

endclass : test01

`endif //TEST__SV



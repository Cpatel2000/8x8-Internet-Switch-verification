//
// Template for UVM-compliant sequencer class
//


`ifndef SLAVE_SEQUENCER__SV
`define SLAVE_SEQUENCER__SV


typedef class eth_data;
class slave_sequencer extends uvm_sequencer # (eth_data);

   `uvm_component_utils(slave_sequencer)
   function new (string name,
                 uvm_component parent);
   super.new(name,parent);
   endfunction:new 
endclass:slave_sequencer

`endif // SLAVE_SEQUENCER__SV

//
// Template for UVM-compliant sequencer class
//


`ifndef ETH_SEQUENCER__SV
`define ETH_SEQUENCER__SV


typedef class eth_data;
class eth_sequencer extends uvm_sequencer # (eth_data);

   `uvm_component_utils(eth_sequencer)
   function new (string name,
                 uvm_component parent);
   super.new(name,parent);
   endfunction:new 
endclass:eth_sequencer

`endif // ETH_SEQUENCER__SV

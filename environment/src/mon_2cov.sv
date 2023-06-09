//
// Template for UVM-compliant Monitor to Coverage Connector Callbacks
//

`ifndef ETH_MONITOR_2COV_CONNECT
`define ETH_MONITOR_2COV_CONNECT
class eth_monitor_2cov_connect extends uvm_component;
   environment_cov cov;
   uvm_analysis_export # (eth_data) an_exp;
   `uvm_component_utils(eth_monitor_2cov_connect)
   function new(string name="", uvm_component parent=null);
   	super.new(name, parent);
   endfunction: new

   virtual function void write(eth_data tr);
      cov.tr = tr;
      -> cov.cov_event;
   endfunction:write 
endclass: eth_monitor_2cov_connect

`endif // ETH_MONITOR_2COV_CONNECT

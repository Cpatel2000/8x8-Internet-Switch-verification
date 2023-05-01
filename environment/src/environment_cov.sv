//
// Template for UVM-compliant Coverage Class
//

`ifndef ENVIRONMENT_COV__SV
`define ENVIRONMENT_COV__SV

class environment_cov extends uvm_component;
   event cov_event;
   eth_data tr;
   uvm_analysis_imp #(eth_data, environment_cov) cov_export;
   `uvm_component_utils(environment_cov)
 
   covergroup cg_trans @(cov_event);
      coverpoint tr.kind;
      // ToDo: Add required coverpoints, coverbins
      src: coverpoint tr.src; 
      dst: coverpoint tr.dst; 
      cross src,dst; 
   endgroup: cg_trans


   function new(string name, uvm_component parent);
      super.new(name,parent);
      cg_trans = new;
      cov_export = new("Coverage Analysis",this);
   endfunction: new

   virtual function write(eth_data tr);
      this.tr = tr;
      -> cov_event;
   endfunction: write

endclass: environment_cov

`endif // ENVIRONMENT_COV__SV


//
// Template for UVM-compliant transaction descriptor


`ifndef ETH_DATA__SV
`define ETH_DATA__SV


class eth_data extends uvm_sequence_item;

   typedef enum {READ, WRITE } kinds_e;
   rand kinds_e kind;
   typedef enum {IS_OK, ERROR} status_e;
   rand status_e status;
   rand byte sa;

   // ToDo: Add constraint blocks to prevent error injection
   // ToDo: Add relevant class properties to define all transactions
   // ToDo: Modify/add symbolic transaction identifiers to match
    rand bit idle;
    rand bit [3:0] delay;
    rand bit [2:0] src,dst;
    rand bit [31:0] payload;

   constraint eth_data_valid {
      // ToDo: Define constraint to make descriptor valid
      delay == 10; 
      idle == 0; 
      status == IS_OK;
   }
   `uvm_object_utils_begin(eth_data) 

      // ToDo: add properties using macros here
   
      `uvm_field_enum(kinds_e,kind,UVM_ALL_ON)
      `uvm_field_enum(status_e,status, UVM_ALL_ON)
      `uvm_field_int(idle, UVM_ALL_ON)
      `uvm_field_int(delay, UVM_ALL_ON)
      `uvm_field_int(src, UVM_ALL_ON)
      `uvm_field_int(dst, UVM_ALL_ON)
      `uvm_field_int(payload, UVM_ALL_ON)
   `uvm_object_utils_end
 
   extern function new(string name = "Trans");
endclass: eth_data


function eth_data::new(string name = "Trans");
   super.new(name);
endfunction: new


`endif // ETH_DATA__SV

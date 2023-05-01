//
// Template for UVM-compliant physical-level monitor
//

`ifndef ETH_MONITOR__SV
`define ETH_MONITOR__SV


typedef class eth_data;
typedef class eth_monitor;

class eth_monitor_callbacks extends uvm_callback;

   // ToDo: Add additional relevant callbacks
   // ToDo: Use a task if callbacks can be blocking


   // Called at start of observed transaction
   virtual function void pre_trans(eth_monitor xactor,
                                   eth_data tr);
   endfunction: pre_trans


   // Called before acknowledging a transaction
   virtual function pre_ack(eth_monitor xactor,
                            eth_data tr);
   endfunction: pre_ack
   

   // Called at end of observed transaction
   virtual function void post_trans(eth_monitor xactor,
                                    eth_data tr);
   endfunction: post_trans

   
   // Callback method post_cb_trans can be used for coverage
   virtual task post_cb_trans(eth_monitor xactor,
                              eth_data tr);
   endtask: post_cb_trans

endclass: eth_monitor_callbacks

   

class eth_monitor extends uvm_monitor;

   uvm_analysis_port #(eth_data) mon_analysis_port;  //TLM analysis port
   typedef virtual eth_intf v_if;
   v_if mon_if;
   // ToDo: Add another class property if required
   extern function new(string name = "eth_monitor",uvm_component parent);
   `uvm_register_cb(eth_monitor,eth_monitor_callbacks);
   `uvm_component_utils_begin(eth_monitor)
      // ToDo: Add uvm monitor member if any class property added later through field macros

   `uvm_component_utils_end
      // ToDo: Add required short hand override method


   extern task rcv1pkt(int i,ref eth_data tr);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task tx_monitor();

endclass: eth_monitor


function eth_monitor::new(string name = "eth_monitor",uvm_component parent);
   super.new(name, parent);
   mon_analysis_port = new ("mon_analysis_port",this);
endfunction: new

function void eth_monitor::build_phase(uvm_phase phase);
   super.build_phase(phase);
   //ToDo : Implement this phase here

endfunction: build_phase

function void eth_monitor::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "mon_if", mon_if);
endfunction: connect_phase

function void eth_monitor::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase); 
   //ToDo: Implement this phase here

endfunction: end_of_elaboration_phase


function void eth_monitor::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
   //ToDo: Implement this phase here

endfunction: start_of_simulation_phase


task eth_monitor::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
   // ToDo: Implement reset here

endtask: reset_phase


task eth_monitor::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure your component here
endtask:configure_phase


task eth_monitor::run_phase(uvm_phase phase);
   super.run_phase(phase);
  // phase.raise_objection(this,""); //Raise/drop objections in sequence file
   fork
      tx_monitor();
   join
  // phase.drop_objection(this);

endtask: run_phase

task automatic eth_monitor::rcv1pkt(int i, ref eth_data tr);
    eth_data tmp;
    tmp = new();
    tmp.dst=i;
    while (mon_if.pck.frame_n[i]!=='0) @(mon_if.pck) ;
    while (mon_if.pck.valid_n[i]!=='0) @(mon_if.pck) ;
    for (int j=0;j<32;j=j+1) begin
      tmp.payload[j] <= mon_if.pck.di[i];
      @(mon_if.pck);
    end
    //mon_analysis_port.write(tmp);
    tr = tmp; 

endtask:rcv1pkt


task eth_monitor::tx_monitor();
   forever begin
      eth_data tr;
      // ToDo: Wait for start of transaction

      `uvm_do_callbacks(eth_monitor,eth_monitor_callbacks,
                    pre_trans(this, tr))
      `uvm_info("environment_MONITOR", "Starting transaction...",UVM_LOW)
      // ToDo: Observe first half of transaction

      // ToDo: User need to add monitoring logic and remove $finish
   //   `uvm_info("environment_MONITOR"," User need to add monitoring logic ",UVM_LOW)
//	  $finish;
      rcv1pkt(7,tr); 
      `uvm_do_callbacks(eth_monitor,eth_monitor_callbacks,
                    pre_ack(this, tr))
      // ToDo: React to observed transaction with ACK/NAK
      `uvm_info("environment_MONITOR", "Completed transaction...",UVM_LOW)
      `uvm_info("environment_MONITOR", tr.sprint(),UVM_LOW)
      `uvm_do_callbacks(eth_monitor,eth_monitor_callbacks,
                    post_trans(this, tr))
      mon_analysis_port.write(tr);
   end
endtask: tx_monitor

`endif // ETH_MONITOR__SV

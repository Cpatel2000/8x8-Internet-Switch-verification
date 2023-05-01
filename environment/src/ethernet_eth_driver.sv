//
// Template for UVM-compliant physical-level transactor
//

`ifndef ETH_DRIVER__SV
`define ETH_DRIVER__SV

typedef class eth_data;
typedef class eth_driver;

class eth_driver_callbacks extends uvm_callback;

   // ToDo: Add additional relevant callbacks
   // ToDo: Use "task" if callbacks cannot be blocking

   // Called before a transaction is executed
   virtual task pre_tx( eth_driver xactor,
                        eth_data tr);
                                   
     // ToDo: Add relevant code

   endtask: pre_tx


   // Called after a transaction has been executed
   virtual task post_tx( eth_driver xactor,
                         eth_data tr);
     // ToDo: Add relevant code

   endtask: post_tx

endclass: eth_driver_callbacks


class eth_driver extends uvm_driver # (eth_data);

   
   typedef virtual eth_intf v_if; 
   v_if drv_if;
   `uvm_register_cb(eth_driver,eth_driver_callbacks); 
   
   extern function new(string name = "eth_driver",
                       uvm_component parent = null); 
 
      `uvm_component_utils_begin(eth_driver)
      // ToDo: Add uvm driver member
      `uvm_component_utils_end
   // ToDo: Add required short hand override method


   extern task send1pkt(int i,eth_data tr); 
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task send(eth_data tr); 
   extern protected virtual task tx_driver(int i);

endclass: eth_driver


function eth_driver::new(string name = "eth_driver",
                   uvm_component parent = null);
   super.new(name, parent);

   
endfunction: new


function void eth_driver::build_phase(uvm_phase phase);
   super.build_phase(phase);
   //ToDo : Implement this phase here

endfunction: build_phase

function void eth_driver::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "mst_if", drv_if);
endfunction: connect_phase

function void eth_driver::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
   if (drv_if == null)
       `uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
endfunction: end_of_elaboration_phase

function void eth_driver::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
   //ToDo: Implement this phase here
endfunction: start_of_simulation_phase

 
task eth_driver::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
   // ToDo: Reset output signals
     drv_if.mck.frame_n <= '1;
     drv_if.mck.valid_n <= '1;
     drv_if.mck.di <= 'x;
     repeat (1) @(drv_if.mck); 
endtask: reset_phase

task eth_driver::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure your component here
endtask:configure_phase


task eth_driver::run_phase(uvm_phase phase);
   super.run_phase(phase);
   repeat (50) @(drv_if.mck); 
   // phase.raise_objection(this,""); //Raise/drop objections in sequence file
   fork 
      tx_driver(0);
   join
   // phase.drop_objection(this);
endtask: run_phase

task eth_driver::send1pkt(int i,eth_data tr); 
   if (i!== tr.src) $display("ERROR %d != %d",i,tr.src); 
   if (tr.idle)  
     begin 
       repeat(tr.delay)  @(drv_if.mck); 
       return;
     end
   $display($time, ": Sending packet src=%1d:dst=%1d",tr.src,tr.dst); 
   repeat(5) @(drv_if.mck); 
   drv_if.mck.frame_n[tr.src] <= 1'b0; 
   drv_if.mck.di[tr.src] <= tr.dst[0]; 
   @(drv_if.mck)  drv_if.mck.di[tr.src] <= tr.dst[1];
   @(drv_if.mck)  drv_if.mck.di[tr.src] <= tr.dst[2];
   @(drv_if.mck)  drv_if.mck.di[tr.src] <= 1'b0;
   // Padding
   repeat(1) @(drv_if.mck) ;
   for (int i=0;i<32;i=i+1) begin
     drv_if.mck.valid_n[tr.src] <= 1'b0;
     drv_if.mck.di[tr.src] <= tr.payload[i];
     drv_if.mck.frame_n[tr.src] <= i==31;
     @(drv_if.mck);
   end
   drv_if.mck.valid_n[tr.src] <= 1'b1;
   drv_if.mck.di[tr.src] <= 1'bx;
   repeat (5)  @(drv_if.mck);

endtask:send1pkt
    


task eth_driver::tx_driver(int i);
 forever begin
      eth_data tr;
      // ToDo: Set output signals to their idle state
      this.drv_if.master.async_en      <= 0;
      `uvm_info("environment_DRIVER", "Starting transaction...",UVM_LOW)
      seq_item_port.get_next_item(tr);
       if (tr.dst==7 && tr.src==7) send1pkt(tr.src,tr); 
      seq_item_port.item_done();
      `uvm_info("environment_DRIVER", "Completed transaction...",UVM_LOW)
      `uvm_info("environment_DRIVER", tr.sprint(),UVM_HIGH)
      `uvm_do_callbacks(eth_driver,eth_driver_callbacks,
                    post_tx(this, tr))

   end
endtask : tx_driver

task eth_driver::send(eth_data tr);
   // ToDo: Drive signal on interface
   case (tr.src) 
    0: send1pkt(0,tr); 
    1: send1pkt(1,tr); 
    2: send1pkt(2,tr); 
    3: send1pkt(3,tr); 
    4: send1pkt(4,tr); 
    5: send1pkt(5,tr); 
    6: send1pkt(6,tr); 
    7: send1pkt(7,tr); 
   endcase
endtask: send


`endif // ETH_DRIVER__SV



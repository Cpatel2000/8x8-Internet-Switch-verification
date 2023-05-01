//
// Template for UVM-compliant interface
//

`ifndef SLAVE_INTF__SV
`define SLAVE_INTF__SV

interface slave_intf (input bit clk, input bit rst);

   // ToDo: Define default setup & hold times

   parameter setup_time = 5/*ns*/;
   parameter hold_time  = 3/*ns*/;

   // ToDo: Define synchronous and asynchronous signals as wires
   wire [7:0] frame_n;
   wire [7:0] valid_n;
   wire [7:0] di;
   wire [7:0]dout;
   wire [7:0] valido_n;
   wire[7:0] frameo_n;

   logic       async_en;
   logic       async_rdy;

   // ToDo: Define one clocking block per clock domain
   //       with synchronous signal direction from a
   //       master perspective

   clocking mck @(posedge clk);
      default input #setup_time output #hold_time;

      // ToDo: List the synchronous signals here

   endclocking: mck

   clocking sck @(posedge clk);
      default input #setup_time output #hold_time;

      // ToDo: List the synchronous signals here

   endclocking: sck

   clocking pck @(posedge clk);
      default input #setup_time output #hold_time;

      //ToDo: List the synchronous signals here
     input frameo_n,valido_n,dout;

   endclocking: pck

   modport master(clocking mck,
                  output async_en,
                  input  async_rdy);

   modport slave(clocking sck,
                 input  async_en,
                 output async_rdy);

   modport passive(clocking pck,
                   input async_en,
                   input async_rdy);

endinterface: slave_intf

`endif // SLAVE_INTF__SV

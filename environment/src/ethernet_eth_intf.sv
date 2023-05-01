//
// Template for UVM-compliant interface
//

`ifndef ETH_INTF__SV
`define ETH_INTF__SV

interface eth_intf (input bit clk, input bit reset_n);

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
output frame_n,valid_n,di;
input dout,valido_n,frameo_n;

      // ToDo: List the synchronous signals here

   endclocking: mck

   clocking sck @(posedge clk);
      default input #setup_time output #hold_time;

      // ToDo: List the synchronous signals here

   endclocking: sck

   clocking pck @(posedge clk);
      default input #setup_time output #hold_time;
input frame_n,valid_n,di;

      //ToDo: List the synchronous signals here

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

endinterface: eth_intf

`endif // ETH_INTF__SV

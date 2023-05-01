//
// Template for Top module
//

`ifndef ENVIRONMENT_TOP__SV
`define ENVIRONMENT_TOP__SV

module environment_top();

   logic clk;
   logic rst;

   // Clock Generation
   parameter sim_cycle = 10;
   
   // Reset Delay Parameter
   parameter rst_delay = 50;

   always 
      begin
         #(sim_cycle/2) clk = ~clk;
      end

   eth_intf mst_if(clk,rst);
   slave_intf slv_if(clk,rst);
   assign slv_if.valido_n = mst_if.valido_n; 
   assign slv_if.frameo_n = mst_if.frameo_n; 
   assign slv_if.dout = mst_if.dout; 

   environment_tb_mod test(); 
   
   // ToDo: Include Dut instance here
 router dut (.clock(clk), .reset_n(mst_if.reset_n),
 .frame_n(mst_if.frame_n),
 .valid_n(mst_if.valid_n),
 .di(mst_if.di),
 .dout(mst_if.dout),
 .valido_n(mst_if.valido_n),
 .frameo_n(mst_if.frameo_n));

   //Driver reset depending on rst_delay
   initial
      begin
         clk = 0;
         rst = 1;
      #1 rst = 0;
         repeat (rst_delay) @(clk);
         rst = 1'b1;
         @(clk);
   end

endmodule: environment_top

`endif // ENVIRONMENT_TOP__SV

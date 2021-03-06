module motion_cntrl_tb();

// inputs
reg clk, rst_n, go, cnv_cmplt;
reg [2:0] chnnl;
reg[11:0] A2D_res;
// outputs
wire start_conv, IR_in_en, IR_mid_en, IR_out_en;
wire [7:0] LEDs;
wire [10:0] lft, rht;

// A2D stuff
logic MOSI, MISO, SCLK, a2d_SS_n;
logic [11:0] res;

// Instantiate the motion_cntrl() thingy
motion_cntrl iDUT(.clk(clk), .rst_n(rst_n), .go(go), .start_conv(start_conv), .chnnl(chnnl), .cnv_cmplt(cnv_cmplt), .A2D_res(A2D_res),
             .IR_in_en(IR_in_en), .IR_mid_en(IR_mid_en), .IR_out_en(IR_out_en), .LEDs(LEDs), .lft(lft), .rht(rht));

/*A2D_intf iDUT1(.clk(clk),.rst_n(rst_n),.strt_cnv(start_conv),.cnv_cmplt(cnv_cmplt),
	      .chnnl(chnnl),.res(res),.a2d_SS_n(a2d_SS_n),.SCLK(SCLK),.MOSI(MOSI),.MISO(MISO));

// instantiate ADC128S
ADC128S iDUT2(.clk(clk), .rst_n(rst_n), .SS_n(a2d_SS_n), .SCLK(SCLK), .MISO(MISO), .MOSI(MOSI));*/



// 20 clock cycles
always #10 clk = ~clk;

initial begin
	 A2D_res = 12'h614;
    	 // Reset values
   	 clk = 0;
   	 cnv_cmplt = 0;
   	 rst_n = 0;
	 go = 0;
   	 #20;
   	 rst_n = 1;
   	 #20;

   	 // Inner sensors are enabled
	 // First cycle through the FSM (chnnl != 6)
   	 go = 1;
   	 #90000;
	 // cnv_cmplt is asserted for one clock cycle to perform calculations
  	 cnv_cmplt = 1;
  	 #20;
  	 cnv_cmplt = 0;
  	 #1000;
  	 cnv_cmplt = 1;
   	 #20;
   	 cnv_cmplt = 0;
   	 #100;
    
   	 // Middle sensors are enabled
	 // Second cycle through the FSM (chnnl != 6) 
  	 #90000;
   	 cnv_cmplt = 1;
   	 #20;
  	 cnv_cmplt = 0;
   	 #1000;
   	 cnv_cmplt = 1;
   	 #20;
  	 cnv_cmplt = 0;
   	 #100;

   	 // Outer sensors are enabled 
	 // Third cycle through the FSM (chnnl = 6) 
	 // Performs all the PI calculations
   	 #90000;
   	 cnv_cmplt = 1;
   	 #20;
   	 cnv_cmplt = 0;
   	 #1000;
    	 cnv_cmplt = 1;
    	 #20;
    	 cnv_cmplt = 0;
    	 #10000;

    $stop;
    
end

endmodule


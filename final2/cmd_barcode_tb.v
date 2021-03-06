

module cmd_barcode_tb();

reg clk, rst_n;
reg send;
reg [7:0] station_ID; 
reg [21:0] period; 
wire [7:0] ID; 
wire ID_vld, BC, BC_done; 

reg [7:0] cmd;

reg OK2Move;

wire go, buzz, buzz_n;
wire in_transit, clr_cmd_rdy, clr_ID_vld;


cmd_cntrl iCMD(.clk(clk), .rst_n(rst_n), .cmd(cmd), .cmd_rdy(BC_done), .OK2Move(OK2Move),
		 .ID(ID), .ID_vld(ID_vld), .clr_cmd_rdy(clr_cmd_rdy), .in_transit(in_transit),
		 .go(go), .buzz(buzz), .buzz_n(buzz_n), .clr_ID_vld(clr_ID_vld));


barcode iDUT(.clk(clk), .rst_n(rst_n), .BC(BC), .clr_ID_vld(clr_ID_vld), .ID(ID), .ID_vld(ID_vld));

barcode_mimic iMIM(.clk(clk), .rst_n(rst_n), .period(period),
		.send(send), .station_ID(station_ID), .BC_done(BC_done),.BC(BC));

initial clk = 0; 
always #10 clk = ~clk; 

initial begin
	OK2Move = 1; 
	//clr_ID_vld = 0; 
	send = 0;
	cmd = 8'b0111_0000; 
	rst_n = 1; 
	#5
	rst_n = 0; 
	#11
	rst_n = 1;
	#20

//TEST 1; expected output 1110_0111
	period = 22'd1000; 
	station_ID = 8'b0010_0111; 
	#20

	send = 1; 
	#20 
	send = 0; 

	#300000

//TEST 2: expected output: 0001_0100
	//clr_ID_vld = 1; 
	#20
	//clr_ID_vld =0; 
	period = 22'd700; 
	station_ID = 8'b0001_0100; 
	#20

	send = 1; 
	#20 
	send = 0; 

	#300000

//TEST 3: expected output: 0110_0110
	//clr_ID_vld = 1; 
	#20
	//clr_ID_vld =0; 
	period = 22'd816; 
	station_ID = 8'b0010_0110; 
	#20

	send = 1; 
	#20 
	send = 0; 

	#300000


//TEST 4: expected output: 0111_0000
	//clr_ID_vld = 1; 
	#20
	//clr_ID_vld =0; 
	period = 22'd1001; 
	station_ID = 8'b0011_0000; 
	#20

	send = 1; 
	#20 
	send = 0; 

	#300000

	$stop;



end
endmodule 
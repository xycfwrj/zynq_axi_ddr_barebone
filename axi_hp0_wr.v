`timescale  1 ns/10ps
module axi_hp0_wr#(
				parameter STAR_ADDR = 32'h0100_0000)
			(
			input				rst_n,                   
            //input data
			input				i_clk,
			input 				i_data_rst_n,			
			input				i_data_en,
			input[15:0]			i_data,
			
		      //AXI bus, wa channel
			input				AXI_clk,
			output reg[31:0]	AXI_awaddr,		
			output[3:0] 		AXI_awlen,		
			output[2:0] 		AXI_awsize,		
			output[1:0] 		AXI_awburst,	
			output[1:0]			AXI_awlock,		
			output[3:0] 		AXI_awcache,	
			output[2:0] 		AXI_awprot,		
			output[3:0] 		AXI_awqos,		
			output reg			AXI_awvalid,	
			input 				AXI_awready,	
				//write data channel
			output[63:0] 		AXI_wdata,		
			output[7:0] 		AXI_wstrb,		
			output reg			AXI_wlast,		
			output reg			AXI_wvalid,		
			input 				AXI_wready,	
				//response channel
			input[5:0] 			AXI_bid,
			input[1:0] 			AXI_bresp,
			input 				AXI_bvalid,	
			output 				AXI_bready		
		);
 
wire[7:0] 	wrfifo_data_count;	
reg 		wrfifo_rden;		
reg[7:0] 	wrdata_num;			
reg[3:0]    cstate,nstate;

parameter AXI_BURST_LEN	= 16;
parameter STATE_RST  = 4'h0;	
parameter STATE_IDLE = 4'h1; 
parameter STATE_WADD = 4'h2;
parameter STATE_WDAT = 4'h3; 	 
parameter WRITE_DONE = 4'h4;    
parameter END_ADDR = STAR_ADDR + 32'h00400000;

//store input data to fifo, read out by AXI
fifo_generator_0 uut_fifo_generator_0 (
  .rst(~i_data_rst_n),
  .wr_clk(i_clk),
  .rd_clk(AXI_clk),
  .din(i_data),
  .wr_en(i_data_en),
  .rd_en(wrfifo_rden),
  .dout(AXI_wdata),
  .full(),
  .empty(),
  .rd_data_count(wrfifo_data_count)
);
//cross clock
reg w_data_rst_n;
always @(posedge AXI_clk)
	w_data_rst_n <= i_data_rst_n; 		

//axi write state
always @(posedge AXI_clk or negedge rst_n) begin
	if(~rst_n)begin
		cstate <= STATE_RST;
	end
	else begin
		cstate <= nstate;
	end
end 
                                                     																										
always @( * ) begin
	case(cstate)
    STATE_RST: begin
        if(w_data_rst_n) nstate = STATE_IDLE;
        else nstate = STATE_RST;
    end
    STATE_IDLE: begin
		if(!w_data_rst_n) nstate = STATE_RST;
		else if(wrfifo_data_count >= 8'd16) nstate = STATE_WADD;
        else nstate = STATE_IDLE;
    end
	
	STATE_WADD: begin
		if(AXI_awvalid && AXI_awready) nstate = STATE_WDAT;
		else nstate = STATE_WADD;
	end    
    
	STATE_WDAT: begin
		if(wrdata_num >= (AXI_BURST_LEN+1)) nstate = WRITE_DONE;
        else nstate = STATE_WDAT;
    end
	WRITE_DONE: begin
		nstate = STATE_IDLE;
	end
    
    default: begin
        nstate = STATE_RST;
    end
endcase
end

always @(posedge AXI_clk) begin                                                                
	if (!rst_n) wrdata_num <= 'b0;                                                           
	else if(cstate == STATE_WDAT) begin 
		if(wrdata_num == 8'd0) wrdata_num <= wrdata_num + 1'b1; 
		else if((wrdata_num <= AXI_BURST_LEN) && AXI_wready && AXI_wvalid) wrdata_num <= wrdata_num + 1'b1;              
		else wrdata_num <= wrdata_num;
	end                                                              
	else wrdata_num <= 'b0;                                               
end 
	
//generate fifo read signals
always @(*) begin                                                                
	if (cstate == STATE_WDAT) begin
		if(wrdata_num == 8'd0) wrfifo_rden <= 1'b1;
		else if((wrdata_num >= 8'd1) && (wrdata_num < AXI_BURST_LEN) && AXI_wready && AXI_wvalid) wrfifo_rden <= 1'b1;
		else wrfifo_rden <= 1'b0;
	end
	else wrfifo_rden <= 1'b0;                                 
end

//generate AXI write signals
always @(posedge AXI_clk)begin
	if(cstate == STATE_RST) AXI_awaddr <= STAR_ADDR;
	else if(AXI_awvalid && AXI_awready) begin
	   if(AXI_awaddr == END_ADDR) 
	      AXI_awaddr <= STAR_ADDR;
	   else
	      AXI_awaddr <= AXI_awaddr + AXI_BURST_LEN * 8;
	end
end

always @(posedge AXI_clk) begin                                                                
	if (!rst_n) AXI_awvalid <= 1'b0;                                                               
	else if(cstate == STATE_WADD) begin
		if(AXI_awvalid && AXI_awready) AXI_awvalid <= 1'b0;                                                        
		else AXI_awvalid <= 1'b1;
	end
	else AXI_awvalid <= 1'b0;                                 
end    

always @(posedge AXI_clk) begin                                                                
	if (!rst_n) AXI_wvalid <= 1'b0;
	else if((wrdata_num >= 8'd1) && (wrdata_num < AXI_BURST_LEN)) AXI_wvalid <= 1'b1; 
	else if((wrdata_num == AXI_BURST_LEN) && !AXI_wready) AXI_wvalid <= 1'b1;
	else AXI_wvalid <= 1'b0;                                 
end

always @(posedge AXI_clk) begin                                                                
	if (!rst_n) AXI_wlast <= 1'b0;                                                               
	else if((wrdata_num == (AXI_BURST_LEN - 1)) && AXI_wready && AXI_wvalid) AXI_wlast <= 1'b1;  
	else if((wrdata_num == AXI_BURST_LEN) && !AXI_wready) AXI_wlast <= 1'b1;
	else AXI_wlast <= 1'b0;                                 
end

//axi constants
assign AXI_awsize	= 3'b011;	//8 Bytes per burst
assign AXI_awburst	= 2'b01;
assign AXI_awlock	= 2'b00;
assign AXI_awcache	= 4'b0010;
assign AXI_awprot	= 3'h0;
assign AXI_awqos	= 4'h0;
assign AXI_wstrb	= 8'hff;
assign AXI_bready 	= 1'b1;
assign AXI_awlen 	= AXI_BURST_LEN - 1; 
	
	
endmodule


`timescale 1 ps / 1 ps

module axi_ddr_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    key,
    led);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  
  input [1:0] key;
  output[1:0] led;
  
  wire clk_25m;
  wire clk_50m;
  wire clk_100m;  
  wire clk_75m;
  wire sys_rst_n;

  wire AXI_HP0_ACLK;
  wire [31:0]AXI_HP0_araddr;
  wire [1:0]AXI_HP0_arburst;
  wire [3:0]AXI_HP0_arcache;
  wire [5:0]AXI_HP0_arid;
  wire [3:0]AXI_HP0_arlen;
  wire [1:0]AXI_HP0_arlock;
  wire [2:0]AXI_HP0_arprot;
  wire [3:0]AXI_HP0_arqos;
  wire AXI_HP0_arready;
  wire [2:0]AXI_HP0_arsize;
  wire AXI_HP0_arvalid;
  wire [31:0]AXI_HP0_awaddr;
  wire [1:0]AXI_HP0_awburst;
  wire [3:0]AXI_HP0_awcache;
  wire [5:0]AXI_HP0_awid;
  wire [3:0]AXI_HP0_awlen;
  wire [1:0]AXI_HP0_awlock;
  wire [2:0]AXI_HP0_awprot;
  wire [3:0]AXI_HP0_awqos;
  wire AXI_HP0_awready;
  wire [2:0]AXI_HP0_awsize;
  wire AXI_HP0_awvalid;
  wire [5:0]AXI_HP0_bid;
  wire AXI_HP0_bready;
  wire [1:0]AXI_HP0_bresp;
  wire AXI_HP0_bvalid;
  wire [63:0]AXI_HP0_rdata;
  wire [5:0]AXI_HP0_rid;
  wire AXI_HP0_rlast;
  wire AXI_HP0_rready;
  wire [1:0]AXI_HP0_rresp;
  wire AXI_HP0_rvalid;
  wire [63:0]AXI_HP0_wdata;
  wire [5:0]AXI_HP0_wid;
  wire AXI_HP0_wlast;
  wire AXI_HP0_wready;
  wire [7:0]AXI_HP0_wstrb;
  wire AXI_HP0_wvalid;
  
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;

  axi_ddr axi_ddr_i
       (.AXI_HP0_ACLK(AXI_HP0_ACLK),
        .AXI_HP0_araddr(AXI_HP0_araddr),
        .AXI_HP0_arburst(AXI_HP0_arburst),
        .AXI_HP0_arcache(AXI_HP0_arcache),
        .AXI_HP0_arid(AXI_HP0_arid),
        .AXI_HP0_arlen(AXI_HP0_arlen),
        .AXI_HP0_arlock(AXI_HP0_arlock),
        .AXI_HP0_arprot(AXI_HP0_arprot),
        .AXI_HP0_arqos(AXI_HP0_arqos),
        .AXI_HP0_arready(AXI_HP0_arready),
        .AXI_HP0_arsize(AXI_HP0_arsize),
        .AXI_HP0_arvalid(AXI_HP0_arvalid),
        .AXI_HP0_awaddr(AXI_HP0_awaddr),
        .AXI_HP0_awburst(AXI_HP0_awburst),
        .AXI_HP0_awcache(AXI_HP0_awcache),
        .AXI_HP0_awid(AXI_HP0_awid),
        .AXI_HP0_awlen(AXI_HP0_awlen),
        .AXI_HP0_awlock(AXI_HP0_awlock),
        .AXI_HP0_awprot(AXI_HP0_awprot),
        .AXI_HP0_awqos(AXI_HP0_awqos),
        .AXI_HP0_awready(AXI_HP0_awready),
        .AXI_HP0_awsize(AXI_HP0_awsize),
        .AXI_HP0_awvalid(AXI_HP0_awvalid),
        .AXI_HP0_bid(AXI_HP0_bid),
        .AXI_HP0_bready(AXI_HP0_bready),
        .AXI_HP0_bresp(AXI_HP0_bresp),
        .AXI_HP0_bvalid(AXI_HP0_bvalid),
        .AXI_HP0_rdata(AXI_HP0_rdata),
        .AXI_HP0_rid(AXI_HP0_rid),
        .AXI_HP0_rlast(AXI_HP0_rlast),
        .AXI_HP0_rready(AXI_HP0_rready),
        .AXI_HP0_rresp(AXI_HP0_rresp),
        .AXI_HP0_rvalid(AXI_HP0_rvalid),
        .AXI_HP0_wdata(AXI_HP0_wdata),
        .AXI_HP0_wid(AXI_HP0_wid),
        .AXI_HP0_wlast(AXI_HP0_wlast),
        .AXI_HP0_wready(AXI_HP0_wready),
        .AXI_HP0_wstrb(AXI_HP0_wstrb),
        .AXI_HP0_wvalid(AXI_HP0_wvalid),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK_50M(clk_25m),  //really 25MHz
        .FCLK_CLK_100M(clk_100m),
        .FCLK_RESET_N(sys_rst_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb));

        assign AXI_HP0_awid = 6'b00_0001;
        assign AXI_HP0_wid 	= 6'b00_0001;   
        assign AXI_HP0_arid = 6'b00_0001;
        assign AXI_HP0_ACLK = clk_100m;
        assign led[0] = clk_100m;
        assign led[1] = sys_rst_n;
        
        reg [15:0] image_ddr3_wrdb;
        always @(posedge clk_25m or negedge sys_rst_n)
	    if(~sys_rst_n) image_ddr3_wrdb <= 16'd5;
	    else image_ddr3_wrdb <= image_ddr3_wrdb+1'b1;        
        
        axi_hp0_wr	#(
				.STAR_ADDR(32'h0040_0000))
		  u3_axi_hp0_wr(
		 // Outputs
		 .AXI_awaddr	(AXI_HP0_awaddr[31:0]),
		 .AXI_awlen		(AXI_HP0_awlen[3:0]),
		 .AXI_awsize	(AXI_HP0_awsize[2:0]),
		 .AXI_awburst	(AXI_HP0_awburst[1:0]),
		 .AXI_awlock	(AXI_HP0_awlock[1:0]),
		 .AXI_awcache	(AXI_HP0_awcache[3:0]),
		 .AXI_awprot	(AXI_HP0_awprot[2:0]),
		 .AXI_awqos		(AXI_HP0_awqos[3:0]),
		 .AXI_awvalid	(AXI_HP0_awvalid),
		 .AXI_wdata		(AXI_HP0_wdata[63:0]),
		 .AXI_wstrb		(AXI_HP0_wstrb[7:0]),
		 .AXI_wlast		(AXI_HP0_wlast),
		 .AXI_wvalid	(AXI_HP0_wvalid),
		 .AXI_bready	(AXI_HP0_bready),
		 // Inputs
		 .rst_n			(sys_rst_n & key[0]),
		 .i_clk			(clk_25m),
		 .i_data_rst_n	(key[1]),
		 .i_data_en		(1'b1),
		 .i_data		(image_ddr3_wrdb[15:0]),
		 .AXI_clk		(AXI_HP0_ACLK),
		 .AXI_awready	(AXI_HP0_awready),
		 .AXI_wready	(AXI_HP0_wready),
		 .AXI_bid		(AXI_HP0_bid[5:0]),
		 .AXI_bresp		(AXI_HP0_bresp[1:0]),
		 .AXI_bvalid	(AXI_HP0_bvalid)
	); 		        
        
endmodule

module register4bit
(
    input  [3:0] d,
	 input clk,
	 output [3:0] dOut,
    output  clkOut   
);
    reg [3:0] q;
       // Assignment on clock
    always @(posedge clk)
        q <= d;
      // LEDs
    assign dOut = q;
    assign clkOut = clk;
endmodule

module ram4bit_1(
 input  [3:0] d,
 input inpRAM,
 input inpAcc,
 input  clk,
 input [1:0]addr,
  
 //output [3:0] dOutR0,
 //output [3:0] dOutR1,
 output [3:0] muxOut,
 output [3:0] AccOut,
 //count
 //output [3:0] countOut,
 output reg [3:0] countOut,
 
 output clkOut  
); 
  
//reg [3:0] countOut ;  

wire [3:0] dOutR0;
wire [3:0] dOutR1;
wire [3:0] dOutR2;
wire [3:0] dOutR3;

//wire [1:0] demuxOut;
//assign demuxOut[0] = ~addr & clk;
//assign demuxOut[1] =  addr & clk;
wire [3:0] demuxOut;
assign demuxOut[0] = ~addr[1] & ~addr[0] & inpRAM;
assign demuxOut[1] = ~addr[1] &  addr[0] & inpRAM;
assign demuxOut[2] =  addr[1] & ~addr[0] & inpRAM;
assign demuxOut[3] =  addr[1] &  addr[0] & inpRAM; 


/*
my_dff trig0 (
.d(d),
.clk(clk),
.q_led(q_led[0])
);
*/
register4bit R0 (
.d(d),
.clk(demuxOut[0]),
.dOut(dOutR0)
);

register4bit R1 (
.d(d),
.clk(demuxOut[1]),
.dOut(dOutR1)
);
register4bit R2 (
.d(d),
.clk(demuxOut[2]),
.dOut(dOutR2)
);

register4bit R3 (
.d(d),
.clk(demuxOut[3]),
.dOut(dOutR3)
);

//assign muxOut = addr ? dOutR1 : dOutR0;
assign muxOut = addr [1]
        ? (addr [0] ? dOutR3 : dOutR2)
        : (addr [0] ? dOutR1 : dOutR0);
///
register4bit Acc (
.d(muxOut),
.clk(inpAcc),
.dOut(AccOut)
);		  

always @(posedge clk)
countOut <= countOut + 1;

	 assign  clkOut = clk;
endmodule


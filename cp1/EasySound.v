module EasySound(clk, bz1, led9);

input clk;
output reg bz1;
output led9;

parameter inClk = 50000000;		//reference clock
parameter f1 = inClk/500;		//sound frequency @1000 hz.
reg [26:0] tone1;				// count every clk  (max= 67 million)
reg sound1;						//sound1 @ freqeuncy 1 (f1)

always @(posedge clk) begin 
	tone1 = tone1+1;
	if (tone1==f1) begin
		bz1 = ~bz1;
		tone1=0;
	end
end

endmodule
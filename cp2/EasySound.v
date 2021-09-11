module EasySound(clk, bz1, led9);

input clk;
output reg bz1;
output led9;

parameter inClk = 50000000; 	//reference clock
parameter f1 = inClk/1000;  	//sound frequency @1000 hz.
parameter f2 = inClk/8000;	//sound frequency @8000 hz.
parameter tempo = inClk/4;	  //tempo @4 hz.
reg [26:0] tone1; 		// count every clk  (max= 67 million)
reg [26:0] tone2; 		// count every clk  (max= 67 million)
reg [26:0] tempoC; 		// count every clk  (max= 67 million)
reg sound1; 			//sound @ freqeuncy 1
reg sound2;			//sound @ freqeuncy 2
reg soundF;			//for frequency 1 or 2 selecting

always @(posedge clk) begin 	//----------- tempo -----------------
	tempoC = tempoC+1;
	if(tempoC==tempo) begin
		soundF = ~soundF;
		tempoC=0;
	end
end
always @(posedge clk) begin 	//--------------- tone 2 8000 hz. ------------
	tone2 = tone2+1;
	if(tone2==f2) begin
		sound2 = ~sound2;
		tone2=0;
	end
end
always @(posedge clk) begin 	//--------------- tone 1 1000 hz. ------------
	tone1 = tone1+1;
	if(tone1==f1) begin
		sound1 = ~sound1;
		tone1=0;
	end
end
always @(*) begin
	if(soundF == 0)
		bz1 = sound1;
	else
		bz1 = sound2;
end

endmodule
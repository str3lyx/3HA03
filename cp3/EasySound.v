module EasySound(clk, S5, S6, segment, digit, bz1);

input clk, S5, S6;
output reg [7:0] segment;
output digit;
output reg bz1;

parameter inClk = 50_000_000; 	// reference clock
reg startCounting = 0;			// counting flag
reg startAlarming = 0;			// alarming flag

parameter limiter_1hz = inClk/1;
reg [26:0] clk_counter;
parameter initer = 3;					// last digit of my student id is 3
reg [3:0] num = initer;

// ----- counter and setting ----- //

always @(posedge clk) begin
	
	if (S5 == 0) begin
		if (num >= initer)
			startCounting = 1;
	end else if (S6 == 0) begin
		// if it is alarming then stop
		if (startAlarming == 1) begin
			startAlarming = 0;
			num = initer;
		end
	end
	
	if (startCounting == 1) begin
		clk_counter = clk_counter + 1;
	
		if (clk_counter >= limiter_1hz) begin
			num = num - 1;
			if (num >= initer)
				num = initer;
			else if (num == 0) begin
				startAlarming = 1;
				startCounting = 0;
			end
			clk_counter = 0;
		end
	end
	
end

// ----- clock seperator ----- //
parameter f1 = inClk/1000;  	//sound frequency @1000 hz.
parameter f2 = inClk/8000;		//sound frequency @8000 hz.
parameter tempo = inClk/4;	  	//tempo @4 hz.

reg [26:0] tone1; 				// count every clk  (max= 67 million)
reg [26:0] tone2; 				// count every clk  (max= 67 million)
reg [26:0] tempoC; 				// count every clk  (max= 67 million)

reg sound1; 					//sound @ freqeuncy 1
reg sound2;						//sound @ freqeuncy 2
reg soundF;						//for frequency 1 or 2 selecting

// ----- ~4 hz ----- //

always @(posedge clk) begin
	if (startAlarming == 1) begin
		tempoC = tempoC+1;
		if(tempoC==tempo) begin
			soundF = ~soundF;
			tempoC=0;
		end
	end else begin
		tempoC =  0;
		soundF = 0;
	end
end

// ----- ~8000 hz ----- //

always @(posedge clk) begin
	if (startAlarming == 1) begin
		tone2 = tone2+1;
		if(tone2==f2) begin
			sound2 = ~sound2;
			tone2=0;
		end
	end else begin
		tone2 =  0;
		sound2 = 0;
	end
end

// ----- ~1000 hz ----- //

always @(posedge clk) begin
	if (startAlarming == 1) begin
		tone1 = tone1+1;
		if(tone1==f1) begin
			sound1 = ~sound1;
			tone1=0;
		end
	end else begin
		tone1 = 0;
		sound1 = 0;
	end
end

// ----- alarm ----- //

always @(*) begin
	if(soundF == 0)
		bz1 = sound1;
	else
		bz1 = sound2;
end

// ----- 7-segment ----- //

always @(*) begin
    case (num)
		4'b0000: segment = 8'b0011_1111;				// display 0
		4'b0001: segment = 8'b0000_0110;				// display 1
		4'b0010: segment = 8'b0101_1011;				// display 2
		4'b0011: segment = 8'b0100_1111;				// display 3
		4'b0100: segment = 8'b0110_0110;				// display 4
		4'b0101: segment = 8'b0110_1101;				// display 5
		4'b0110: segment = 8'b0111_1101;				// display 6
		4'b0111: segment = 8'b0000_0111;				// display 7
		4'b1000: segment = 8'b0111_1111;				// display 8
		4'b1001: segment = 8'b0110_1111;				// display 9
		default: segment = 8'b0000_0000;
    endcase
end

assign digit = 1;

endmodule
//defining parameters
`define TRUE   1'b1
`define FALSE  1'b0 
`define RED    2'd0
`define YELLOW 2'd1
`define GREEN  2'd2
 
//State definition            HWY     CNTRY
        `define S0	3'd0	//GREEN	  RED
        `define S1	3'd1	//YELLOW	  RED
        `define S2	3'd2	//RED	     RED
        `define S3	3'd3	//RED	     GREEN
        `define S4	3'd4	//RED	     YELLOW

//Delays
`define Y2RDELAY 3 //Yellow to red delay 
`define R2GDELAY 2 //Red to green delay



module trafic_control
                (hwy, cntry, X, clock, clear);

//I/O ports

output [1:0] hwy, cntry;
//2-bit output for 3 states of signal
//GREEN, YELLOW, RED;

reg [1:0] hwy, cntry;
//declared output signals are registers

input X;
//if TRUE, indicates that there is car on
//the country road, otherwise FALSE 

input clock, clear;

//Internal state variables
reg [2:0] state;
reg [2:0] next_state;

//Signal controller starts in S0 state

	initial
		begin
		state = `S0; 
		next_state = `S0;
		hwy = `GREEN;
		cntry = `RED;
	end

//state changes only at positive edge of clock 
always @(posedge clock)
	state = next_state;

//Compute values of main signal and country signal 
always @(state)
begin
  case(state) 

  `S0: begin
       hwy = `GREEN;
       cntry = `RED; 
    end

   `S1: begin
        hwy = `YELLOW;
        cntry = `RED;
     end

   `S2: begin
        hwy = `RED;
        cntry = `RED;
     end 

    `S3: begin
         hwy  = `RED;
         cntry = `GREEN; 
      end

    `S4: begin
         hwy = `RED; 
         cntry = `YELLOW;
      end
endcase
end

//State machine using case statements 
always @(state or clear or X)
	begin
	if(clear)
	next_state = `S0;  
else
   case(state)

	`S0: if( X)
	 next_state = `S1;
else
	next_state = `S0;

	`S1: begin //delay some positive edges of clock 
	repeat(`Y2RDELAY) @(posedge clock);
	next_state = `S2;
end

	`S2: begin //delay some positive edges of clock 
	repeat(`R2GDELAY) @(posedge clock);
	next_state = `S3;
end
 
	`S3: if( X)
	next_state = `S3;
else
	next_state = `S4;

	`S4: begin //delay some positive edges of clock 
	repeat(`Y2RDELAY) @(posedge clock); 	
	next_state = `S0;
end
	default: next_state = `S0; 
	endcase
	end
endmodule

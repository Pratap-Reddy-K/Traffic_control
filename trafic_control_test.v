//stimulous code for testing 

module trafic_control_test;

wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON_CNTRY_RD;

//if TRUE, indicates that there is car on
//the country road 
reg CLOCK, CLEAR;

//Instantiate signal controller

trafic_control SC(MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD, CLOCK, CLEAR);

//Set up monitor 
initial
$monitor($time, "Main Sig = %b Country Sig = %b Car_on_cntry = %b", MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

//Set up clock 
	initial
		begin
		CLOCK = `FALSE;
		forever #5 CLOCK = ~CLOCK;
	end

//control clear signal
	initial
		begin
		CLEAR = `TRUE;
		repeat (5) @(negedge CLOCK); 
		CLEAR = `FALSE;
	end

//apply stimulus
	initial
		begin
		CAR_ON_CNTRY_RD = `FALSE;


		#200 CAR_ON_CNTRY_RD = `TRUE ;
		#100 CAR_ON_CNTRY_RD = `FALSE ;

		#200 CAR_ON_CNTRY_RD = `TRUE;
		#100 CAR_ON_CNTRY_RD = `FALSE;

		#200 CAR_ON_CNTRY_RD = `TRUE; 
		#100 CAR_ON_CNTRY_RD = `FALSE;

		#100 $stop;

		end
endmodule



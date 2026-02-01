`timescale 1ns / 1ps


module tb_cpu;

	// Inputs
	reg rst;
	reg clk;
	reg initialize;
	reg [31:0] instruction_initialize_data;
	reg [31:0] instruction_initialize_address;
	
	//Outputs
	wire [31:0] ALUOut;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.rst(rst), 
		.clk(clk), 
		.initialize(initialize), 
		.instruction_initialize_data(instruction_initialize_data), 
		.instruction_initialize_address(instruction_initialize_address),
		.ALUOut(ALUOut)
	);

	initial begin
		// Initialize Inputs
		rst = 1;
		clk = 0;
		initialize = 1;
		instruction_initialize_data = 0;
		instruction_initialize_address = 0;

		#100;
      //instruction_initialize_data = 32'b001000_00001_00110_00000_00000_00_0101;
      
        instruction_initialize_address = 0;
		instruction_initialize_data = 32'b001000_00001_01000_00000_00000_00_0101;      // ADDI R8, R1, 5
		#20;
		instruction_initialize_address = 4;
		instruction_initialize_data = 32'b000000_00000_00010_00001_00000_10_0000;      // ADD R1, R0, R2
		#20;
		instruction_initialize_address = 8;
		instruction_initialize_data = 32'b000000_00100_00100_01000_00000_10_0010;      // SUB R8, R4, $4
		#20;
		instruction_initialize_address = 12;
		instruction_initialize_data = 32'b000000_00101_00110_00111_00000_10_0101;      // OR R5, R6, 7
		#20;
		instruction_initialize_address = 16;
        instruction_initialize_data = 32'b001111_00000_00000_00000_00000_00_0111;   //LUI R0, 7		#20;
		#20;
		
		instruction_initialize_address = 20;
		instruction_initialize_data = 32'b000010_00000_00000_00000_00000_00_0110; //Jump 24
		#20;

        
		
		instruction_initialize_address = 24;
        instruction_initialize_data = 32'b000000_00111_01001_00001_00000_10_1010;      // SLT, R1  R7, R9,
        #20;
		
		instruction_initialize_address = 28;
        instruction_initialize_data = 32'b000101_00000_00001_11111_11111_11_1110;      // BEQ R0, R0, 2
        #20;
		
		
		
		
		initialize = 0;
		rst = 0;
		
	end
      
always
#5 clk = ~clk;
endmodule


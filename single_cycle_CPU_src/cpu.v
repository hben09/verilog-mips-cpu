`timescale 1ns / 1ps

// 8 bit data
// 4 bit wide address for memories and reg file
// 32 bit wide instruction
// 4 bit immediate

module cpu(
     rst,
	 clk,
	 initialize,
	 instruction_initialize_data,
	 instruction_initialize_address,
	 
	 ALUOut
    );
	 
	 	 
     input rst;
	 input clk;
	 input initialize;
	 input [31:0] instruction_initialize_data;
	 input [31:0] instruction_initialize_address;
	 output [31:0] ALUOut;
	 
	 wire [31:0] PC_out;
	 wire [31:0] instruction;
	 wire [31:0] instruction_mem_out;
	 assign instruction = (initialize) ? 32'hFFFF_FFFF : instruction_mem_out;
    InstrMem InstructionMemory (instruction_mem_out , instruction_initialize_data  , (initialize) ? instruction_initialize_address : PC_out , initialize , clk);
	
	
	
	 wire [1:0] ALUOp;
	 wire MemRead;
	 wire MemtoReg;
	 wire RegDst;
	 wire Branch; 
	 wire ALUSrc;
	 wire MemWrite;
	 wire RegWrite;
	 wire Jump;
	 wire LUI;
	 wire BranchNE;
	 
    control Control(instruction [31:26], ALUOp, MemRead, MemtoReg, RegDst, Branch, ALUSrc, MemWrite, RegWrite, Jump, LUI, BranchNE); 
	 
	 
	 
	 wire           [31:0]            write_data;
    wire           [4:0]             write_register;
    wire		       [31:0]            read_data_1, read_data_2;
	 wire				 [31:0]            MemOut;
	 
	 
	 
	 mux #(5) Write_Reg_MUX (RegDst, instruction[20:16], instruction[15:11], write_register);
	 nbit_register_file Register_File(write_data, read_data_1, read_data_2, instruction[25:21] , instruction[20:16], write_register, RegWrite, clk);
    
	 
	 
	 wire [31:0] immediate;
    sign_extend Sign_Extend( instruction[15:0], immediate);
	 
	 
	 wire [31:0] ALU_input_2;
    wire zero_flag;
	 wire [2:0] ALU_function;
	 mux #(32) ALU_Input_2_Mux (ALUSrc, read_data_2, immediate, ALU_input_2);
	 ALU_control ALU_Control(instruction[5:0], ALUOp, ALU_function);
    ALU ALU(read_data_1, ALU_input_2, ALU_function, ALUOut, zero_flag);
	 
	 
	 Memory Data_Memory(ALUOut, read_data_2, MemOut, MemRead, MemWrite, clk);


    mux #(32) ALU_Mem_Select_MUX (MemtoReg, ALUOut, MemOut, write_data);	 
	 
	 
	 wire [31:0] PC_in;
	 PC Program_Counter(PC_out, PC_in, clk, rst);
	 
	 wire [31:0] PC_plus_4;
	 Adder #(32) PC_Increment_Adder (PC_out, 32'd4, PC_plus_4);
	 
	 wire [27:0] instruction25to0_x_4;
	 shift_left_2 #(28) instruction_shift_left_two (instruction[25:0], instruction25to0_x_4);
     
     wire [31:0] jump_address;
     assign jump_address = {PC_plus_4[31:28], instruction25to0_x_4};
     

	 wire [31:0] Branch_target_address;
	 wire [31:0] immediate_x_4;
	 shift_left_2 #(32) Shift_Left_Two (immediate, immediate_x_4);
	 Adder #(32) Branch_Target_Adder (PC_plus_4, immediate_x_4, Branch_target_address);
	 
	 
	 wire PCSrc;
	 wire [31:0] PC_Input_MUX_Output;
//	 and Branch_And (PCSrc, Branch, zero_flag);
	 
//	 mux #(32) branch_control (zero_flag, Branch, BranchNE, PCSrc);
	 
	 assign PCSrc = zero_flag ? Branch : BranchNE;
	 
	 mux #(32) PC_Input_MUX (PCSrc, PC_plus_4, Branch_target_address, PC_Input_MUX_Output);
	 
	 mux #(32) jump_control_MUX (Jump, PC_Input_MUX_Output, jump_address, PC_in);
	 							 
endmodule

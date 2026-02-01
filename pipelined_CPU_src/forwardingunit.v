`timescale 1ns / 1ps

module forwardingunit(
    input  [4:0] IDEX_Rs,
    input  [4:0] IDEX_Rt,
    input  [4:0] EXMEM_Rd,
    input        EXMEM_RegWrite,
    input  [4:0] MEMWB_Rd,
    input        MEMWB_RegWrite,
    output [1:0] ForwardA,
    output [1:0] ForwardB
);

    // ForwardA logic (for Rs / ALU input A)
    // 2'b10 = forward from EX/MEM (previous instruction)
    // 2'b01 = forward from MEM/WB (two instructions ago)
    // 2'b00 = no forwarding

    assign ForwardA =
        // EX/MEM forwarding (highest priority)
        (EXMEM_RegWrite && (EXMEM_Rd != 5'b0) && (EXMEM_Rd == IDEX_Rs)) ? 2'b10 :
        // MEM/WB forwarding (only if EX/MEM not forwarding)
        (MEMWB_RegWrite && (MEMWB_Rd != 5'b0) && (MEMWB_Rd == IDEX_Rs) &&
         !(EXMEM_RegWrite && (EXMEM_Rd != 5'b0) && (EXMEM_Rd == IDEX_Rs))) ? 2'b01 :
        // No forwarding
        2'b00;

    // ForwardB logic (for Rt / ALU input B)
    assign ForwardB =
        // EX/MEM forwarding (highest priority)
        (EXMEM_RegWrite && (EXMEM_Rd != 5'b0) && (EXMEM_Rd == IDEX_Rt)) ? 2'b10 :
        // MEM/WB forwarding (only if EX/MEM not forwarding)
        (MEMWB_RegWrite && (MEMWB_Rd != 5'b0) && (MEMWB_Rd == IDEX_Rt) &&
         !(EXMEM_RegWrite && (EXMEM_Rd != 5'b0) && (EXMEM_Rd == IDEX_Rt))) ? 2'b01 :
        // No forwarding
        2'b00;

endmodule

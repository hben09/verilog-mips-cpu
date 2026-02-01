`timescale 1ns / 1ps

module hazardunit(
    input        MemReadEx,
    input  [4:0] IDEX_Rt,
    input  [4:0] ID_Rs,
    input  [4:0] ID_Rt,
    output       IFIDWrite,
    output       PCWrite,
    output       HazardMux
);

   wire hazard_detected;

   assign hazard_detected = MemReadEx &&
                            (IDEX_Rt != 5'b0) &&
                            ((IDEX_Rt == ID_Rs) || (IDEX_Rt == ID_Rt));

   assign IFIDWrite = ~hazard_detected;
   assign PCWrite   = ~hazard_detected;
   assign HazardMux = hazard_detected;

endmodule

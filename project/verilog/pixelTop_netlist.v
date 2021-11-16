
(* top =  1  *)
(* src = "pixelTop.v:3" *)
module PIXEL_TOP(clk, reset, VBN, RAMP, dataOut);
  (* src = "pixelTop.v:7" *)
  wire _0_;
  (* src = "pixelTop.v:6" *)
  wire _1_;
  (* src = "pixelTop.v:4" *)
  wire _2_;
  (* src = "pixelTop.v:11" *)
  wire _3_;
  (* src = "pixelTop.v:11" *)
  wire _4_;
  (* src = "pixelTop.v:10" *)
  wire [7:0] DataOut1;
  (* src = "pixelTop.v:10" *)
  wire [7:0] DataOut2;
  (* src = "pixelTop.v:7" *)
  input RAMP;
  (* src = "pixelTop.v:6" *)
  input VBN;
  (* src = "pixelTop.v:4" *)
  input clk;
  (* src = "pixelTop.v:11" *)
  wire convert;
  (* src = "pixelTop.v:8" *)
  output [31:0] dataOut;
  (* src = "pixelTop.v:11" *)
  wire erase;
  (* src = "pixelTop.v:11" *)
  wire expose;
  (* src = "pixelTop.v:11" *)
  wire read0;
  (* src = "pixelTop.v:11" *)
  wire read1;
  (* src = "pixelTop.v:5" *)
  input reset;
  ANX1_CV _5_ (
    .A(_2_),
    .B(_3_),
    .Y(_0_)
  );
  ANX1_CV _6_ (
    .A(_2_),
    .B(_4_),
    .Y(_1_)
  );
  (* module_not_derived = 32'd1 *)
  (* src = "pixelTop.v:12" *)
  PIXEL_STATE pState1 (
    .clk(clk),
    .convert(convert),
    .erase(erase),
    .expose(expose),
    .read0(read0),
    .read1(read1),
    .reset(reset)
  );
  (* module_not_derived = 32'd1 *)
  (* src = "pixelTop.v:13" *)
  PIXEL_ARRAY pa1 (
    .CONVERT(convert),
    .DataOut1(DataOut1),
    .DataOut2(DataOut2),
    .ERASE(erase),
    .EXPOSE(expose),
    .RAMP(RAMP),
    .READ0(read0),
    .READ1(read1),
    .RESET(reset),
    .VBN(VBN)
  );
  assign dataOut = { DataOut2, DataOut1, DataOut2, DataOut1 };
  assign _2_ = clk;
  assign _3_ = convert;
  assign RAMP = _0_;
  assign _4_ = expose;
  assign VBN = _1_;
endmodule

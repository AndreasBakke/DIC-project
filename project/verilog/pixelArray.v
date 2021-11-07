`timescale 1 ns / 1 ps

//vi må finne ut hva som er bus og hva som er felles.
//Bus: Data.
//Felles: Klokke, Reset, Erase, Read,
//Tror jeg skal lage 4  Pixelarrays som skal kunne kjøres sammen.


module PIXEL_ARRAY(
    input logic VBN,
    input logic RAMP,
    input logic RESET,
    input logic ERASE,
    input logic EXPOSE,
    input logic READ,
    inout [7:0] DATA1,
    inout [7:0] DATA2,
    inout [7:0] DATA3,
    inout [7:0] DATA4
);

PIXEL_SENSOR #(.dv_pixel(0.2)) ps1(VBN, RAMP, RESET, ERASE, EXPOSE, READ, DATA1);
PIXEL_SENSOR #(.dv_pixel(0.5)) ps2(VBN, RAMP, RESET, ERASE, EXPOSE, READ, DATA2);//Gir ulike antatte photocurrents for å skille
PIXEL_SENSOR #(.dv_pixel(0.7)) ps3(VBN, RAMP, RESET, ERASE, EXPOSE, READ, DATA3);
PIXEL_SENSOR #(.dv_pixel(0.9)) ps4(VBN, RAMP, RESET, ERASE, EXPOSE, READ, DATA4);

endmodule
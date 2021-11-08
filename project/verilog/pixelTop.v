`timescale 1ns / 1ps

module PIXEL_TOP (
    input   logic   clk,
    input   logic   reset,
    input   logic   VBN,
    input   logic   RAMP,
    inout   [7:0]   DATA1,
    inout   [7:0]   DATA2,
    inout   [7:0]   DATA3,
    inout   [7:0]   DATA4
);

    wire erase, read, expose, convert;

    PIXEL_STATE pState1(clk, reset, erase, read, expose, convert);
    PIXEL_ARRAY pa1(VBN, RAMP, reset, erase, expose, read, DATA1, DATA2, DATA3, DATA4);



endmodule
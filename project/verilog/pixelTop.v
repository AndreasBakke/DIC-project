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

    wire erase, read, expose, convert;//Kan den være wire, eller bør den bli logic? 

    PIXEL_STATE pState1(clk, reset, erase, read, expose, convert);
    PIXEL_ARRAY pa1(VBN, RAMP, reset, erase, expose, read, DATA1, DATA2, DATA3, DATA4);

endmodule


//Notat til meg selv
//Todo:
// Flytte ADC/DAC kontroll til et bedre sted, vi kan ikke kontrolere dette fra pixelTop uten å inkludere READ og sånt. Det vil vi ikke
// Kanskje heller ha bias og ramp inn til FSM?
// Da kan vi sette data hele veien opp tror jeg.
// Vi må uansett ha ADC/DAC et annet sted enn i pixelTop /pixelTop_tb. Kan de implementeres i PixelArray?

//todo:Må lage bedre system for DATA1/2 er jævlig mye styr nå
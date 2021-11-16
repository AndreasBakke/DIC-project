`timescale 1ns / 1ps

module PIXEL_TOP (
    input   logic   clk,
    input   logic   reset,
    input   logic   VBN,
    input   logic   RAMP,
    output  logic [31:0]  dataOut
);
    logic [7:0] DataOut1, DataOut2;
    wire erase, read0, read1, expose, convert;
    PIXEL_STATE pState1(clk, reset, erase, read0, read1, expose, convert);
    PIXEL_ARRAY pa1(VBN, RAMP, reset, erase, expose, read0, read1, convert, DataOut1, DataOut2);
    
    always_ff @(posedge clk or posedge reset)begin
        if(reset)begin
            dataOut =0;
        end
        else begin
            if(read0)begin
                dataOut[7:0]    <= DataOut1;
                dataOut[15:8]   <= DataOut2;
            end//Her leser vi ut til databussen avhengig av hvilken read-state vi er i
            else if (read1) begin
                dataOut[23:16]  <= DataOut1;
                dataOut[31:24]  <= DataOut2;
            end
        end
    end

    //"Driver" de analoge signalene
    assign RAMP = convert ? clk : 0; //Så lenge denne kjører, øker adc i pixelsensoren frem til adc>tmp
    assign VBN = expose ? clk : 0; //Clk eller 0 avhengig av om state=expose - da synker tmp på hver posedge clk

endmodule
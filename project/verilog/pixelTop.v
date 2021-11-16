`timescale 1ns / 1ps

module PIXEL_TOP (
    input   logic   clk,
    input   logic   reset,
    input   logic   VBN,
    input   logic   RAMP,
    output  logic [31:0]  dataOut
);
    logic [7:0] DataOut1, DataOut2;
    wire erase, read0, read1, expose, convert;//Kan den være wire, eller bør den bli logic? 
    PIXEL_STATE pState1(clk, reset, erase, read0, read1, expose, convert);
    PIXEL_ARRAY pa1(VBN, RAMP, reset, erase, expose, read0, read1, convert, DataOut1, DataOut2);
    
    always_ff @(posedge clk or posedge reset)begin
        if(reset)begin
            dataOut =0;
        end
        else begin
            if(read0)begin//disse ligger en "state bak"?
                dataOut[7:0]    <= DataOut1;
                dataOut[15:8]   <= DataOut2;
            end
            else if (read1) begin
                dataOut[23:16]  <= DataOut1;
                dataOut[31:24]  <= DataOut2;
            end
        end
    end

    //"Driver" de analoge signalene
    assign RAMP = convert ? clk : 0; //Så lenge denne kjører, øker adc i pixelsensoren frem til adc>tmp
    assign VBN = expose ? clk : 0; //Clk eller 0 avhengig av om state=expose

endmodule


//Notat til meg selv
//Todo:
//To databuser fra pixelArray, en for hver kolonne. Disse må leses av på forskjellig tid.


// Flytte ADC/DAC kontroll til et bedre sted, vi kan ikke kontrolere dette fra pixelTop uten å inkludere READ og sånt. Det vil vi ikke
// Kanskje heller ha bias og ramp inn til FSM?
// Da kan vi sette data hele veien opp tror jeg.
// Vi må uansett ha ADC/DAC et annet sted enn i pixelTop /pixelTop_tb. Kan de implementeres i PixelArray?

//todo:Må lage bedre system for DATA1/2 er jævlig mye styr nå
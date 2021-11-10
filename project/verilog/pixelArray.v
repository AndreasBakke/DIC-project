`timescale 1 ns / 1 ps

//vi må finne ut hva som er bus og hva som er felles.
//Bus: Data.
//Felles: Klokke, RESET, Erase, Read,
//Tror jeg skal lage 4  Pixelarrays som skal kunne kjøres sammen.


module PIXEL_ARRAY(
    input logic VBN,
    input logic RAMP,
    input logic RESET,
    input logic ERASE,
    input logic EXPOSE,
    input logic READ,
    input logic CONVERT,
    output  reg [7:0] DATA1,
    output  reg [7:0] DATA2,
    output  reg [7:0] DATA3,
    output  reg [7:0] DATA4
);

    tri[7:0] pixData1;
    tri[7:0] pixData2;
    tri[7:0] pixData3;
    tri[7:0] pixData4;

    PIXEL_SENSOR #(.dv_pixel(0.48)) ps1(VBN, RAMP, RESET, ERASE, EXPOSE, READ, pixData1);
    PIXEL_SENSOR #(.dv_pixel(0.5)) ps2(VBN, RAMP, RESET, ERASE, EXPOSE, READ, pixData2);//Gir ulike antatte photocurrents for å skille
    PIXEL_SENSOR #(.dv_pixel(0.52)) ps3(VBN, RAMP, RESET, ERASE, EXPOSE, READ, pixData3);
    PIXEL_SENSOR #(.dv_pixel(0.54)) ps4(VBN, RAMP, RESET, ERASE, EXPOSE, READ, pixData4);


    //--------------------------
    //  ADC/DAC 
    //--------------------------
    logic[7:0] data;
    //Dette er egentlig analoge signaler, men vi simulerer de på denne måten

    assign pixData1 = READ ? 8'bZ: data;//føler dette bør flyttes.
    assign pixData2 = READ ? 8'bZ: data;
    assign pixData3 = READ ? 8'bZ: data;
    assign pixData4 = READ ? 8'bZ: data;

    always_ff @(posedge RAMP or posedge VBN or posedge RESET) begin
        if(RESET) begin
            data=0;
        end
        if(CONVERT) begin
            data+=1; //Så lenge convert =1, vil anaRamp kjøre^^ og data inkrementeres (counter (digital ramp)) når adc>tmp latches verdien til data, men data fortsetter å inkrementeres
        //p_data blir data så lenge cmp=0 (som stopper når adc>tmp som nevnt ovenfor skjer)
        end
        else begin
            data=0;//Så lenge vi ikke converter er data 0.
        end
    end

    //Leser ut til databus
    always_ff @(posedge READ or posedge RESET) begin
       if(RESET) begin
            DATA1 = 0;
            DATA2 = 0;
            DATA3 = 0;
            DATA4 = 0;   
       end
       else begin
          if(READ)begin
            DATA1 <= pixData1;
            DATA2 <= pixData2;
            DATA3 <= pixData3;
            DATA4 <= pixData4;
          end
       end
    end


endmodule
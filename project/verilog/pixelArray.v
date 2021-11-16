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
    input logic READ0,
    input logic READ1,
    input logic CONVERT,
    output  reg [7:0] DataOut1,
    output  reg [7:0] DataOut2
);

    wire [7:0] pixData1;
    wire [7:0] pixData2;
    wire [7:0] pixData3;
    wire [7:0] pixData4;

    PIXEL_SENSOR #(.dv_pixel(0.48)) ps1(VBN, RAMP, RESET, ERASE, EXPOSE, READ0, pixData1);
    PIXEL_SENSOR #(.dv_pixel(0.5)) ps2(VBN, RAMP, RESET, ERASE, EXPOSE, READ0, pixData2);//Gir ulike antatte photocurrents for å skille
    PIXEL_SENSOR #(.dv_pixel(0.52)) ps3(VBN, RAMP, RESET, ERASE, EXPOSE, READ1, pixData3);
    PIXEL_SENSOR #(.dv_pixel(0.54)) ps4(VBN, RAMP, RESET, ERASE, EXPOSE, READ1, pixData4);


    //--------------------------
    //  ADC/DAC 
    //--------------------------
    logic[7:0] data;
    //Dette er egentlig analoge signaler, men vi simulerer de på denne måten
    //Kjører databus som input til pixelsensorene når vi ikke leser. Når vi leser blir den benyttet som output
    assign pixData1 = READ0 ? 8'bZ: data;//føler dette bør flyttes.
    assign pixData2 = READ0 ? 8'bZ: data;
    assign pixData3 = READ1 ? 8'bZ: data;
    assign pixData4 = READ1 ? 8'bZ: data;

    //Driver digital ramp.
    always_ff @(posedge RAMP or posedge VBN or posedge RESET) begin
        if(RESET) begin
            data=0;
        end
        if(CONVERT) begin
            data= data + 1; //Så lenge convert =1, vil anaRamp kjøre^^ og data inkrementeres (counter (digital ramp)) når adc>tmp latches verdien til data, men data fortsetter å inkrementeres
        //p_data blir data så lenge cmp=0 (som stopper når adc>tmp som nevnt ovenfor skjer)
        end
        else begin
            data= 0;//Så lenge vi ikke converter er data 0.
        end
    end
    
    //Leser ut til databus
    always_ff @(posedge READ0 or posedge READ1 or posedge RESET) begin
       if(RESET) begin
            DataOut1=0;
            DataOut2=0;  
       end
       else begin
          if(READ0)begin
            DataOut1 <= pixData1;
            DataOut2 <= pixData2;
          end
          else if (READ1) begin
            DataOut1 <= pixData3;
            DataOut2 <= pixData4;
              
          end
       end
    end
endmodule
`timescale 1ns/1ps

module pixelTop_tb();

    //Setter opp klokke og reset
    logic clk=0;    
    logic reset=0;
    parameter integer clk_period =500;
    parameter integer sim_end =clk_period*7200;
    always #clk_period clk=~clk;

    //analoge signaler
    logic anaBias;
    logic anaRamp;

    //digital
    tri[7:0] pixData1;
    tri[7:0] pixData2;
    tri[7:0] pixData3;
    tri[7:0] pixData4;

    PIXEL_TOP       pt1(clk, reset, anaBias, anaRamp, pixData1, pixData2, pixData3, pixData4);



    // logic[7:0] data;
    // //Dette er egentlig analoge signaler, men vi simulerer de på denne måten
    // assign anaRamp = pt1.convert ? clk : 0; //Så lenge denne kjører, øker adc i pixelsensoren frem til adc>tmp
    // assign anaBias = pt1.expose ? clk : 0; //Clk eller 0 avhengig av om state=expose

    // assign pixData1 = pt1.read ? 8'bZ: data;//føler dette bør flyttes.
    // assign pixData2 = pt1.read ? 8'bZ: data;
    // assign pixData3 = pt1.read ? 8'bZ: data;
    // assign pixData4 = pt1.read ? 8'bZ: data;


    // always_ff @(posedge clk or posedge reset) begin
    //     if(reset) begin
    //         data=0;
    //     end
    //     if(pt1.convert) begin
    //         data+=1; //Så lenge convert =1, vil anaRamp kjøre^^ og data inkrementeres (counter (digital ramp)) når adc>tmp latches verdien til data, men data fortsetter å inkrementeres
    //     //p_data blir data så lenge cmp=0 (som stopper når adc>tmp som nevnt ovenfor skjer)
    //     end
    //     else begin
    //         data=0;//Så lenge vi ikke converter er data 0.
    //     end
    // end


    //leser av data
    // logic [7:0] pixelDataOut1;
    // logic [7:0] pixelDataOut2;
    // logic [7:0] pixelDataOut3;
    // logic [7:0] pixelDataOut4;
    // always_ff @(posedge clk or posedge reset) begin
    //    if(reset) begin
    //      pixelDataOut1=0;
    //      pixelDataOut2=0;
    //      pixelDataOut3=0;
    //      pixelDataOut4=0;
    //    end
    //    else begin
    //       if(pt1.read)begin
    //         pixelDataOut1 <= pixData1;
    //         pixelDataOut2 <= pixData2;
    //         pixelDataOut3 <= pixData3;
    //         pixelDataOut4 <= pixData4;
    //       end
    //    end
    // end


    //-----------------
    // Kjør testbench
    //-----------------
    initial
        begin
            reset = 1;

            #clk_period  reset=0;

            $dumpfile("pixelTop.vcd");
            $dumpvars(0, pixelTop_tb);     
            #600000; reset=1;#clk_period;
            reset=0;
            #sim_end
            $stop;

     end

endmodule
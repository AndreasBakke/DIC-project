`timescale 1 ns / 1 ps


module pixelState_tb;

    logic clk=0;
    logic reset=0;
    parameter integer clk_period = 500; //5ns
    parameter integer sim_end = clk_period*2400;
    always #clk_period clk=~clk;



    //anaologe signaler
    logic   anaBias;
    logic   anaRamp;
    logic   anaReset;

    assign anaReset =1;

    //digital
    wire erase;
    wire expose;
    wire read;
    wire convert;
    tri[7:0] pixData1;
    tri[7:0] pixData2;
    tri[7:0] pixData3;
    tri[7:0] pixData4;

    PIXEL_ARRAY     pa1(anaBias, anaRamp, reset, erase, expose, read, pixData1, pixData2, pixData3, pixData4);
    PIXEL_STATE pafsm1(clk, reset, erase, read, expose, convert);


    //----------------------------------------------------
    // DAC og ADC
    //----------------------------------------------------

    logic[7:0] data;
    assign anaRamp = convert ? clk : 0; //som over. Så lenge denne kjører, øker adc i pixelsensoren frem til adc>tmp

    assign anaBias = expose ? clk : 0; //Clk eller 0 avhengig av om state=expose

    assign pixData1 = read ? 8'bZ: data;
    assign pixData2 = read ? 8'bZ: data;
    assign pixData3 = read ? 8'bZ: data;
    assign pixData4 = read ? 8'bZ: data;


    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            data=0;
        end
        if(convert) begin
            data+=1; //Så lenge convert =1, vil anaRamp kjøre^^ og data inkrementeres (counter (digital ramp)) når adc>tmp latches verdien til data, men data fortsetter å inkrementeres
        //p_data blir data så lenge cmp=0 (som stopper når adc>tmp som nevnt ovenfor skjer)
        end
        else begin
            data=0;//Så lenge vi ikke converter er data 0.
        end
    end

//leser av databus
    logic [7:0] pixelDataOut1;
    logic [7:0] pixelDataOut2;
    logic [7:0] pixelDataOut3;
    logic [7:0] pixelDataOut4;
    always_ff @(posedge clk or posedge reset) begin
       if(reset) begin
         pixelDataOut1=0;
         pixelDataOut2=0;
         pixelDataOut3=0;
         pixelDataOut4=0;
       end
       else begin
          if(read)begin
            pixelDataOut1 <= pixData1;
            pixelDataOut2 <= pixData2;
            pixelDataOut3 <= pixData3;
            pixelDataOut4 <= pixData4;
          end
       end
    end


//-----------------
// Kjør testbench
//-----------------
    initial
        begin
            reset = 1;

            #clk_period  reset=0;

            $dumpfile("pixelState.vcd");
            $dumpvars(0, pixelState_tb);

            #sim_end
            $stop;

     end


endmodule
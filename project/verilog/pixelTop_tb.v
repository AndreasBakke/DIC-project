`timescale 1ns/1ps

module pixelTop_tb();

    //Setter opp klokke og reset
    logic clk=0;    
    logic reset=0;
    parameter integer clk_period =57;//klokker for 1 syklus: 525. Tid for 1 syklus (spice)- 60us: clk= 
    parameter integer sim_end =clk_period*7200;
    always #clk_period clk=~clk;

    //analoge signaler
    logic anaBias;
    logic anaRamp;

    //digital
    logic [31:0] databus;

    PIXEL_TOP       pt1(clk, reset, anaBias, anaRamp, databus);

    //-----------------
    // Kjør testbench
    //-----------------
    initial
        begin
            reset = 1;

            #clk_period  reset=0;

            $dumpfile("pixelTop.vcd");
            $dumpvars(0, pixelTop_tb);     
            #80000; reset=1;#clk_period;//Test reset @ 80us
            reset=0;
            #sim_end
            $stop;

        end
    

endmodule
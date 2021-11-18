`timescale 1 ns / 1 ps
//WARNING --- OUTDATED AFTER UPDATES IN pixelArray.v - Do not use


//Merk at oppsett er veldig likt pixelSensor_tb.v for enkelhet
module pixelArray_tb;

//----------
// setter opp klokke, reset og testbench parametre
//----------

logic clk = 0;
logic reset = 0;
parameter integer clk_period = 500;//500ns
parameter integer sim_end = clk_period*2400;//sim varer 2400 klokkesykluser
always #clk_period clk = ~clk;


//------
// Setter opp arrayen
//------

//Analoge signaler
logic anaBias;
logic anaRamp;
logic anaReset;

assign anaReset=1;

//Digital
logic erase;
logic expose;
logic read;
tri[7:0] pixData1;
tri[7:0] pixData2;
tri[7:0] pixData3;
tri[7:0] pixData4;

//Array

PIXEL_ARRAY  pa1(anaBias, anaRamp, reset, erase, expose, read, pixData1, pixData2, pixData3, pixData4);


//-------------
// State Machine (Copied from pixelSensor_tb.v)
//-------------

 parameter ERASE=0, EXPOSE=1, CONVERT=2, READ=3, IDLE=4;

   logic               convert;
   logic               convert_stop;
   logic [2:0]         state,next_state;   //States
   integer           counter;            //Delay counter in state machine

   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = 5;

   // Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read <= 0;
           expose <= 0;
           convert = 1;
        end
        READ: begin
           erase <= 0;
           read <= 1;
           expose <= 0;
           convert <= 0;
        end
        IDLE: begin
           erase <= 0;
           read <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)


   // Control the state transitions.
   //TODO: The counter should probably be an always_comb. Might be a good idea
   //to also reset the counter from the state machine, i.e provide the count
   //down value, and trigger on 0
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ;
                 state <= IDLE;
              end
           end
           READ:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)


//---------------------------------------
//DAC/ADC
//---------------------------------------
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

            $dumpfile("pixelArray_tb.vcd");
            $dumpvars(0,pixelArray_tb);

            #sim_end
            $stop;

     end

endmodule

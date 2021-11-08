`timescale 1 ns / 1 ps



module PIXEL_STATE (
    input   logic   clk,
    input   logic   reset,
    output  logic   erase,
    output  logic   read,
    output  logic   expose,
    output  logic   convert
);
//Bruker mye fra testbenchen picelArray_tb.v da vi har implementert en fsm der
    parameter integer c_erase = 5;
    parameter integer c_expose = 255;
    parameter integer c_convert = 255;
    parameter integer c_read = 5;

//--------------------------------------
// State Machine - self made (men med mye likt tb)
//--------------------------------------
    parameter   ERASE=0, EXPOSE=1, CONVERT=2, READ=3, IDLE=4;
    logic [2:0] state;
    integer counter=c_erase;
    integer next_counter=c_expose;

    always_ff @(negedge clk) begin
        case(state)
            ERASE: begin
                erase   <= 1;
                expose  <= 0;
                convert <= 0;
                read    <= 0;
            end
            EXPOSE: begin
                erase   <= 0;
                expose  <= 1;
                convert <= 0;
                // read    <= 0;//prøver først uten
                // vbn     = clk;
            end
            CONVERT: begin
                erase   <= 0;
                expose  <= 0;
                convert <= 1;
                read    <= 0;
                // vbn     = 0;//Går dette?
                // ramp    = clk;
            end
            READ: begin
                erase   <= 0;
                expose  <= 0;
                convert <= 0;
                read    <= 1;
                // ramp    = 0;
            end
        endcase
    end


//Bruk always_comb istedenfor siden dette er kombinatorikk
    always_ff @(posedge clk or posedge reset) begin
        counter = counter -1;
        if(reset)begin
            state = ERASE;
            counter = c_erase;
            next_counter=c_expose;
            convert=0;//Kan denne sløyfes?
            // ramp =0;
            // vbn =0;
        end
        else begin
            if (!counter) begin
                case (state)
                    ERASE: begin
                        state       = EXPOSE;
                        counter     =next_counter;
                        next_counter= c_convert;
                    end
                    EXPOSE: begin
                        state       = CONVERT;
                        counter     =next_counter;
                        next_counter= c_read;
                    end
                    CONVERT: begin
                        state       = READ; 
                        counter     =next_counter;
                        next_counter= c_erase;
                    end
                    READ: begin
                        state       = ERASE; 
                        counter     =next_counter;
                        next_counter= c_expose;
                    end
                endcase
            end //end if(!counter)
        end//end else
    end //end always_comb
    
    //-----
    //ADC/DAC control
    //-----


endmodule




//Jeg må implementere dette på et vis....
// //DAC/ADC
// //---------------------------------------
// logic[7:0] data;
// assign anaRamp = convert ? clk : 0; //som over. Så lenge denne kjører, øker adc i pixelsensoren frem til adc>tmp

// assign anaBias = expose ? clk : 0; //Clk eller 0 avhengig av om state=expose

// assign pixData1 = read ? 8'bZ: data;
// assign pixData2 = read ? 8'bZ: data;
// assign pixData3 = read ? 8'bZ: data;
// assign pixData4 = read ? 8'bZ: data;


// always_ff @(posedge clk or posedge reset) begin
//     if(reset) begin
//         data=0;
//     end
//     if(convert) begin
//         data+=1; //Så lenge convert =1, vil anaRamp kjøre^^ og data inkrementeres (counter (digital ramp)) når adc>tmp latches verdien til data, men data fortsetter å inkrementeres
//     //p_data blir data så lenge cmp=0 (som stopper når adc>tmp som nevnt ovenfor skjer)
//     end
//     else begin
//         data=0;//Så lenge vi ikke converter er data 0.
//     end
// end



// //leser av databus
//     logic [7:0] pixelDataOut1;
//     logic [7:0] pixelDataOut2;
//     logic [7:0] pixelDataOut3;
//     logic [7:0] pixelDataOut4;
//     always_ff @(posedge clk or posedge reset) begin
//        if(reset) begin
//          pixelDataOut1=0;
//          pixelDataOut2=0;
//          pixelDataOut3=0;
//          pixelDataOut4=0;
//        end
//        else begin
//           if(read)begin
//             pixelDataOut1 <= pixData1;
//             pixelDataOut2 <= pixData2;
//             pixelDataOut3 <= pixData3;
//             pixelDataOut4 <= pixData4;
//           end
//        end
//     end
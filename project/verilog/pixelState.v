`timescale 1 ns / 1 ps

module PIXEL_STATE (
    input   logic   clk,
    input   logic   reset,
    output  logic   erase,
    output  logic   read0,
    output  logic   read1,
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
    parameter   ERASE=0, EXPOSE=1, CONVERT=2, READ0=3, READ1 =4;
    logic [2:0] state;
    integer counter=c_erase;
    integer next_counter=c_expose;

    always_ff @(negedge clk) begin
        case(state)
            ERASE: begin
                erase   <= 1;
                expose  <= 0;
                convert <= 0;
                read0   <= 0;
                read1   <= 0;
            end
            EXPOSE: begin
                erase   <= 0;
                expose  <= 1;
                convert <= 0;
                read0   <= 0;
                read1   <= 0;
                // vbn     = clk;
            end
            CONVERT: begin
                erase   <= 0;
                expose  <= 0;
                convert <= 1;
                read0   <= 0;
                read1   <= 0;
                // vbn     = 0;//Går dette?
                // ramp    = clk;
            end
            READ0: begin
                erase   <= 0;
                expose  <= 0;
                convert <= 0;
                read0 <= 1;
                read1 <= 0;
            end
            READ1: begin
                erase   <= 0;
                expose  <= 0;
                convert <= 0;
                read0 <= 0;
                read1 <= 1;
            end
        endcase
    end


//Bruk always_comb istedenfor siden dette er kombinatorikk
    always_ff @(posedge clk or posedge reset) begin
        if(reset)begin
            state = ERASE;
            counter = c_erase;
            next_counter=c_expose;
            convert=0;
        end
        else begin
            if (!counter) begin
                case (state)
                    ERASE: begin
                        state       = EXPOSE;
                        counter     = next_counter;
                        next_counter= c_convert;
                    end
                    EXPOSE: begin
                        state       = CONVERT;
                        counter     = next_counter;
                        next_counter= c_read;
                    end
                    CONVERT: begin
                        state       = READ0; 
                        counter     = next_counter;
                        next_counter= c_read;
                    end
                    READ0: begin
                        state       = READ1; 
                        counter     = next_counter;
                        next_counter= c_erase;
                    end
                    READ1: begin
                        state       = ERASE;
                        counter     = next_counter;
                        next_counter= c_expose;
                    end
                endcase
            end //end if(!counter)
        end//end else
        counter = counter -1;
    end //end always_comb

endmodule



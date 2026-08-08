//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Address Generator
//==============================================================

module address_generator
(
    input               clk,
    input               reset,
    input               enable,

    output      [7:0]   pixel_address,
    output reg  [3:0]   row,
    output reg  [3:0]   col,
    output reg          pixel_valid,
    output reg          frame_done
);

    //----------------------------------------------------------
    // Pixel Address = Row * 16 + Column
    //----------------------------------------------------------

    assign pixel_address = {row, col};

    //----------------------------------------------------------
    // Address Generation
    //----------------------------------------------------------

    always @(posedge clk or posedge reset)
    begin

        if(reset)
        begin
            row         <= 4'd0;
            col         <= 4'd0;

            pixel_valid <= 1'b0;
            frame_done  <= 1'b0;
        end

        else if(enable)
        begin

            //--------------------------------------------------
            // First cycle after reset:
            // Hold address 0,0 and make it valid.
            //--------------------------------------------------

            if(!pixel_valid)
            begin
                pixel_valid <= 1'b1;
                frame_done  <= 1'b0;

                row <= 4'd0;
                col <= 4'd0;
            end

            //--------------------------------------------------
            // Normal pixel operation
            //--------------------------------------------------

            else
            begin

                if(row == 4'd15 && col == 4'd15)
                begin

                    //--------------------------------------------------
                    // Last pixel was just processed
                    //--------------------------------------------------

                    frame_done  <= 1'b1;
                    pixel_valid <= 1'b0;

                    row <= 4'd0;
                    col <= 4'd0;

                end

                else if(col == 4'd15)
                begin

                    col <= 4'd0;
                    row <= row + 1'b1;

                    pixel_valid <= 1'b1;
                    frame_done  <= 1'b0;

                end

                else
                begin

                    col <= col + 1'b1;

                    pixel_valid <= 1'b1;
                    frame_done  <= 1'b0;

                end

            end

        end

        else
        begin

            pixel_valid <= 1'b0;
            frame_done  <= 1'b0;

        end

    end

endmodule
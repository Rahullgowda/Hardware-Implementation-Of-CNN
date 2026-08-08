//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Window Generator
// Description : Simple 3x3 Window Generator
//==============================================================

module window_generator
#(
    parameter IMAGE_WIDTH = 16,
    parameter DATA_WIDTH  = 8,
    parameter ADDR_WIDTH  = 4
)
(
    input clk,
    input reset,

    input pixel_valid,
    input signed[DATA_WIDTH-1:0]pixel_in,

    input      [ADDR_WIDTH-1:0]     row,
    input      [ADDR_WIDTH-1:0]     col,

    output reg                      window_valid,
    output reg [ADDR_WIDTH-1:0] window_row,
    output reg [ADDR_WIDTH-1:0] window_col,

    output reg signed [DATA_WIDTH-1:0]     w0,
    output reg signed [DATA_WIDTH-1:0]     w1,
    output reg signed [DATA_WIDTH-1:0]     w2,

    output reg signed [DATA_WIDTH-1:0]     w3,
    output reg signed [DATA_WIDTH-1:0]     w4,
    output reg signed [DATA_WIDTH-1:0]     w5,

    output reg signed [DATA_WIDTH-1:0]     w6,
    output reg signed [DATA_WIDTH-1:0]     w7,
    output reg signed [DATA_WIDTH-1:0]     w8
);

    //----------------------------------------------------------
    // Internal Image Memory
    //----------------------------------------------------------

    reg signed [DATA_WIDTH-1:0] image_mem [0:IMAGE_WIDTH-1][0:IMAGE_WIDTH-1];

    integer i;
    integer j;
    reg [ADDR_WIDTH-1:0] row_d;
    reg [ADDR_WIDTH-1:0] col_d;

    reg pixel_valid_d;

    //----------------------------------------------------------
    // Store Incoming Pixels
    //----------------------------------------------------------

    always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        window_row <= 0;
        window_col <= 0;

        row_d <= 0;
        col_d <= 0;
        pixel_valid_d <= 0;

        window_valid <= 0;

        w0 <= 0;
        w1 <= 0;
        w2 <= 0;

        w3 <= 0;
        w4 <= 0;
        w5 <= 0;

        w6 <= 0;
        w7 <= 0;
        w8 <= 0;

        //--------------------------------------------------
        // Clear Image Memory
        //--------------------------------------------------

        for(i=0;i<IMAGE_WIDTH;i=i+1)
        begin
            for(j=0;j<IMAGE_WIDTH;j=j+1)
            begin
                image_mem[i][j] <= 0;
            end
        end

    end

    else
    begin

        //--------------------------------------------------
        // Stage 1 : Store Pixel
        //--------------------------------------------------

        if(pixel_valid)
        begin
            image_mem[row][col] <= pixel_in;
        end

        //--------------------------------------------------
        // Delay Row / Col
        //--------------------------------------------------

        row_d <= row;
        col_d <= col;

        pixel_valid_d <= pixel_valid;

        //--------------------------------------------------
        // Default
        //--------------------------------------------------

        window_valid <= 0;

        //--------------------------------------------------
        // Stage 2 : Generate Window
        //--------------------------------------------------

        if(pixel_valid_d && (row_d>=2) && (col_d>=2))
        begin

            w0 <= image_mem[row_d-2][col_d-2];
            w1 <= image_mem[row_d-2][col_d-1];
            w2 <= image_mem[row_d-2][col_d];

            w3 <= image_mem[row_d-1][col_d-2];
            w4 <= image_mem[row_d-1][col_d-1];
            w5 <= image_mem[row_d-1][col_d];

            w6 <= image_mem[row_d][col_d-2];
            w7 <= image_mem[row_d][col_d-1];
            w8 <= image_mem[row_d][col_d];
            window_row <= row_d;
            window_col <= col_d;

            window_valid <= 1'b1;

        end

    end

end

endmodule
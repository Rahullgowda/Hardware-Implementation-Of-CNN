//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Image Memory
// Author  : Rahul Gowda
//==============================================================

module image_memory
(
    input      [7:0] address,

    output [7:0] pixel
);

    // Image Memory

    reg [7:0] image_memory [0:255];

    // Load Image

    initial
    begin
        $readmemh(
"D:/single layer hardware cnn project/hardware/memory/input_image.mem",
image_memory
);
    end

    // Asynchronous Read

assign pixel = image_memory[address];

endmodule
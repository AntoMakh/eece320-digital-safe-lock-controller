// EECE 320 – Phase 1 configuration
// Members (IDs): 202500415, 202502112
// Auth tag: 726d048e059c
// Automatically generated; do not modify. Include at top of each Verilog source and testbench.

`define PRIORITY_DIR  1'b0  // For 3 or more keys pressed: lowest index wins.
`define DUAL_KEY_POL  2'd2  // If exactly two keys are pressed: select the higher-index key.
`define POLARITY      1'b1     // common-anode display.
`define GLYPH_TARGET  4'd4 // digit to modify (0..9 only)
`define GLYPH_MASK    7'b1010000            // XOR with canonical pattern BEFORE polarity inversion

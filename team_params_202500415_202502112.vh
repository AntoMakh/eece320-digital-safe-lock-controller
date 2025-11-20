// EECE 320 – Phase 1 + 2 configuration
// Members (IDs): 202500415, 202502112
// Auth tag: 726d048e059c
// Automatically generated; do not modify. Include at top of each Verilog source and testbench.

// --- Phase 1: keypad and display behavior ---------------------------------
`define PRIORITY_DIR      1'b0  // For 3 or more keys pressed: lowest index wins.
`define DUAL_KEY_POL      2'd2  // If exactly two keys are pressed: select the higher-index key.
`define POLARITY          1'b1     // common-anode display.
`define GLYPH_TARGET      4'd4 // digit to modify (0..9 only)
`define GLYPH_MASK        7'b1010000            // XOR with canonical pattern BEFORE polarity inversion

// --- Phase 2: digital safe datapath parameters ---------------------------
`define PASSCODE          16'h9070  // logical passcode: {D3,D2,D1,D0}
`define STORED_MASK       16'h2130  // nibble perm: stored = {D[2],D[1],D[3],D[0]}
`define TIMER_MAX_CYCLES  4'd10  // interval_timer reload value (cycles)
`define MODE_ENTER        3'b010  // display "entered code"
`define MODE_ERROR        3'b001  // display "Err" message
`define MODE_BLANK        3'b100  // blank display
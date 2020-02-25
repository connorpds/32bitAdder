`include "mem_access.v"
`include "execute.v"
`include "control.v"
`include "inst_fetch.v"
//single cycle CPU datapath.
//components are pipeline stages and control module
module single_cycle
(
  input wire reset,
  input wire clk,
  input wire [31:0] instruction,
  input wire [31:0] mem_contents,
  output wire [31:0] mem_addr,
  output wire [31:0] PC
  )

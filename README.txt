The Pattern Processor (PAT). 32-bit implementation.
===================================================

This repository contains the implementation of the 32-bit version of the PAT processor.
This processor has been taped out on an AMS 0.18um High Voltage process.

Documentation for the PAT processor can be found in the docs directory at github.com/pat-processor/docs/


Repository Overview
-------------------

The repository contains verilog design files and a Cadence verilog-to-OA or verilog-to-DEF flow, mixed with Synopsys optimisation.
The end product is suitable for either immediate tape-out or import into Virtuoso for further processing.

The following directories exist, and have the following use:

* design_compiler - files for use when optimising the datapath using Synopsys Design Compiler.
* encounter - files for Cadence Encounter place and route.
* hdl - verilog design files for the processor and support circuitry
* oa - Cadence OpenAccess layout
* rc-compiler - scripts for and output from Cadence RTL Compiler, for synthesis of verilog to technology mapped verilog
* reports - implementation reports e.g. area reports from the synthesis tools
* testbenches - RTL testbenches and Modelsim test scripts


Contact
-------

The maintainer of this repository is Simon Hollis (simon A  T  cs.bris.ac.uk)
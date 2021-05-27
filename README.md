## Availability evaluation in a simulated SD-WAN

This repository provides a ***Matlab*** environment that resembles a **Software Defined Wide Area Network** in terms of:

- Traffic Pattern
- Real time *End-to-End* (E2E) delay experienced by foreground application packets
- Packet forwarding

It is possible to evaluate the results of a simulation in terms of availability with two possible analysis: **Sensitivity** and **Combined Delay and Traffic Analysis** (C.D.T.A.).

## Getting started 

Download  <a href="https://it.mathworks.com/products/matlab.html " target="_top">Matlab</a> and install the *Simulink* package. 

Download this repository on your PC.

Navigate to Simulink folder, open Matlab and add the folder realTimeEvaluation to the Matlab search path.  

## Running the application

##### Sensitivity analysis

With a sensitivity analysis we can evaluate numerical increase in the availability provided by our SD-WAN solution.

The first step is to define the proper simulation parameters within the *main_sensitivityAnalysis.m* and *standardSetup.m* script.

Then it is enough to run *main_sensitivityAnalysis.m* script in order to obtain the results of the sensitivity analysis.

##### C.D.T.A.

With a C.D.T.A. we want to  calculate the numerical decrease of the availability due to the randomness contributions within the E2E delay and the traffic patterns of the simulation.

First we need to define the proper simulation parameters within the *main_CDTA.m* and *standardSetup.m* script.

Then it is enough to run *main_CDTA.m*.

## Improvements

## Troubleshooting

- If the simulation returns an error like: "**The results are not accurate enough**" it means that during the simulation there is too much variability among the various repetitions that constitute the simulation. To solve this issue try to change the simulation parameters: in particular the 1 or 2 - threshold mechanism and the minThreshold and maxThreshold values

## Warnings

- Tested only  in the context of two virtual overlay paths, primary and backup, for the connection between two remote branches of an enterprise







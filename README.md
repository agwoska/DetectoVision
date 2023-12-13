# DetectoVision

A near real-time detection system to track physical objects using FPGA technology and a camera for enhanced image processing.

This project was completed for EC 551 at Boston University.

**Team Members:**
- Mehedi Hassan
- Visaal Nekkanti
- Andrew Woska
- Abin George

## Table of Contents

1. [Getting Started](#getting-started)
2. [Code To Look At](#code-to-look-at)
3. [Hardware](#hardware)
4. [Peripherals](#peripherals)
5. [Licenses and Contributions](#licenses-and-contributions)
6. [Video](#video)
7. [Known Problems](#known-problems)

## Getting Started

The Verilog files for out implementation are located in ![Sources](./Sources) along with the ESP32-CAM implementation.

The Xilinx IP and Vivado files are located in ![Vivado Files](./Vivado%20Files). 
Since we are using the Basys 3, make sure to use the correct ![directory](./Vivado%20Files/Basys).
The ![Nexys implementation](./Vivado%20Files/Nexys) was used for simulation purposes.
The hardware layout is given in a ![later section](#hardware).

## Code To Look At

The image processing algorithm is located in `Sources/Full Integration - Basys/houghAccumulator.v` or
![here](./Sources/Full%20Integration%20-%20Basys/houghAccumulator.v).

## Hardware

This project requires two pieces of hardware:
- FPGA
  - Basys 3 was used for implementation
  - Nexys A7 was used for testing but has a different constraint file.
- Camera
  - ESP32-CAM was used for the initial implementation
  - OV7670 is used for the current implementation

## Peripherals

### BRAM
All fully integrated modules use a BRAM IP, which may not transfer well when pulling this repo. For this reason, the following is an image of the IP block.

![BRAM IP](https://github.com/agwoska/DetectoVision/assets/66330225/8e281228-dafa-4932-bf13-3c9873e1f388)

## Licenses and Contributions

This project uses parts of the Xilinx IP.

This project is licensed [here](./LICENSE).

## Video

The demo video is located ![here](https://drive.google.com/drive/folders/191mPTwozpH7jWF0dYr3jjbuj1WBnaC5o?usp=sharing) on Google Drive.
You must have the correct access to get to it.
Reach out to Andrew at agwoska@bu.edu or andrew@woska.org for access if needed.

Title: Team DetectoVision - EC551 Fall 2023

Description:

A near real-time detection system to track physical objects using FPGA technology and a camera for enhanced image processing.

This project was created for EC551 at Boston University.

See our GitHub for more information at: https://github.com/agwoska/DetectoVision

Team Members:
- Mehedi Hassan
- Visaal Nekkanti
- Andrew Woska
- Abin George

## Known Problems

- The ESP32-CAM does not always take an uncorrupted image

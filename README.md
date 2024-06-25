# Electrical-Engineering-Design-Studio-II

3rd year electrical engineering project course offered by the University of British Columbia.

*Course Descrption: Introduction to project management. Problem definition. Design principles and practices. Implementation techniques.  Testing and evaluation. Effective presentations. The technical content includes aspects of electronics, communications, control systems, and motors and machines.*

# Project Description
*Design a digital communication system for audio and data communication.*

## Design Requirements
Our team was assigned to scenario F.

![image](https://github.com/vento277/Electrical-Engineering-Design-Studio-II/assets/63937643/49cbfa81-16c9-4130-8360-441391af1118)

## Role
I was responsible for error encoding/decoing & modulation/demodulation

![image](https://github.com/vento277/Electrical-Engineering-Design-Studio-II/assets/63937643/5993a5e6-7f62-4b1e-983c-becd6fa54cb0)

## Subsystem Design
**Error Encoding:**
Error encoding involves adding redundancy to the original data before transmission. This redundancy enables the receiver to detect and sometimes correct errors that may occur during transmission. 

For example, in a simple parity check, an extra bit is added to a binary sequence. The value of this extra bit is chosen such that the total number of '1's (or '0's) in the sequence, including the parity bit, is always even (or odd). If a single bit gets flipped during transmission, the parity check at the receiver can detect this error.

**Error Decoding:**
Error decoding is the process of interpreting the received data to detect and correct errors introduced during transmission. The receiver uses the redundancy added during encoding to check for errors and, if possible, correct them using error-correcting techniques.

**Importance in Digital Communication Systems Design:**

1. **Reliability:** Error encoding and decoding mechanisms ensure that data can be transmitted accurately even in the presence of noise, interference, or other disturbances in the communication channel.
2. **Efficiency:** By implementing error correction, systems can minimize the need for retransmissions of data due to errors, thereby improving communication efficiency and throughput.

**Modulation:**
Modulation is the process of encoding digital data onto an analog carrier signal for transmission over a communication channel. Modulation allows digital signals, which have a limited bandwidth, to be transmitted over a much wider range of frequencies. 

**Demodulation:**
Demodulation is the process of extracting the original digital data from the received modulated analog signal. It reverses the modulation process to recover the digital information.

**Importance in Digital Communication Systems Design:**

1. **Bandwidth Efficiency:** Modulation allows digital signals, which are typically confined to a narrow bandwidth, to be transmitted efficiently over a wider range of frequencies. This efficient use of bandwidth is essential for accommodating multiple users and diverse types of data in modern communication networks.
2. **Data Transmission:** Modulation techniques facilitate high-speed data transmission rates, enabling the transfer of large volumes of digital information quickly and efficiently across communication networks. This capability is essential for applications requiring real-time data exchange, such as video streaming, online gaming, and teleconferencing.

### Design Decisions
Detailed reasoning can be found in the report (page 11).
| Subsystem      | Technique |
| ----------- | ----------- |
|Error Encoding|Convolutional|
|Error Decoding|Viterbi / Hard Decision|
|Modulation|QPSK|
|Demodulation|QPSK / Hard Decision|

### How it works
#### Error Encoding, Convolutional
#### Error Decoding, Viterbi
#### Modulation, QPSK
#### Demodulation, QPSK

### Potencial Improvements
1. Deploy soft decision decoding. Soft decision decoding involves considering the likelihood (often represented as log-likelihood ratios or LLRs) of each bit instead of definitively assigning bits based on a threshold. It has shown significant error correction performance gains in both our simulation and literature reviews.
2. Deploy interleaver. Convolutional codes, while effective against random errors, can struggle with burst errors (consecutive errors within a short span). Interleaving can spread burst errors across the data stream, thereby making them appear as random errors to the decoder.




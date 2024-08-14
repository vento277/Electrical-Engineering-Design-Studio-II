# Electrical-Engineering-Design-Studio-II
ELEC 391 is a 3rd year electrical engineering project course offered by the University of British Columbia.

*Course Descrption: Introduction to project management. Problem definition. Design principles and practices. Implementation techniques.  Testing and evaluation. Effective presentations. The technical content includes aspects of electronics, communications, control systems, and motors and machines.*

# Workflow
1. **Receive Requirement:** Start by understanding the initial requirement.

2. **Explore Possible Options:** Brainstorm and identify various potential solutions or approaches to meet the requirement.

3. **Literature Review and Preliminary Analysis:** Conduct a comprehensive literature review to evaluate each option based on existing research and practical feasibility. This step aims to quickly narrow down the most promising options.

4. **Detailed Simulation and Feasibility Study:** Perform detailed simulations and feasibility studies on the narrowed-down options to validate their technical viability, performance, and potential challenges.

5. **Hypothesize Project Timeline with FPGA Implementation:** Outline a projected timeline for the project, focusing particularly on the FPGA implementation phase, considering factors like development, testing, and integration.

6. **Final Decision:** Make an informed decision on the optimal solution based on the results of the literature review, simulations, and feasibility studies.

7. **Design Implementation:** Proceed with the detailed design and implementation phase based on the chosen solution, ensuring all technical aspects are carefully considered and executed.

# Project Description
*Reliable communication is a central part of our daily life and something that we often take for
granted unless something goes wrong. In this course you and your team will design a digital
communication system for audio and data communication. The following sections describe your
project based on the requirements and constraints. Your team will be assigned team-specific set
of conditions.*

My Role: Developed the convolutional encoding, viterbi decoding and QPSK mod/demodulation subsystems.

**Design Requirements**

Our team was assigned to scenario F.

![image](https://github.com/vento277/Electrical-Engineering-Design-Studio-II/assets/63937643/49cbfa81-16c9-4130-8360-441391af1118)

**Role**

I was responsible for error encoding/decoing & modulation/demodulation

![image](https://github.com/vento277/Electrical-Engineering-Design-Studio-II/assets/63937643/5993a5e6-7f62-4b1e-983c-becd6fa54cb0)

## Subsystem Design
### [Error Correction](EncDec)
The system incorporates convolutional encoding and Viterbi decoding, based on reviews of related literature, such as ["Convolution Coding and Applications: A Performance Analysis under AWGN Channel"](https://ieeexplore.ieee.org/document/7507304) and ["Comparative Performance Analysis of Block and Convolution Codes"](https://www.ijcaonline.org/archives/volume119/number24/21388-4398/). These studies consistently underscore the efficacy of convolutional codes in error detection and correction, particularly suited for high-demand real-time applications such as audio communication systems.

#### [Encoding](EncDec/CE.v)
The convolutional encoder in our FPGA operates at a ½ code rate with a constraint length of 3, chosen to optimize both computational efficiency and error correction capability. Moreover, the decision on the generator polynomial was guided by insights from ["Goodness Analysis of Generator Polynomial for Convolution Code with Varying Constraint Length"](https://www.ijarcce.com/upload/2016/november-16/IJARCCE%2074.pdf), which identified the [7 5] polynomial combination as the most effective among 12 alternatives considered for our specific design.

#### [Decoding](EncDec/Viterbi_Decoder.v)
The Viterbi decoder is configured with a traceback depth of 16, based on guidelines provided in ["A Truncation Depth Rule of Thumb for Convolutional Codes"](https://ieeexplore.ieee.org/document/4601052). Initially, we adhered to the 5-multiple rule (suggesting a depth of 15), but further optimization using two’s complement representation led us to adjust it to 16 for enhanced FPGA performance.

### [Modulation](ModDemod)
The choice of QPSK modulation scheme was considered due to the potential risk of higher-order modulations exceeding BER thresholds specified in our design requirements. Simulations for hard, soft, and unquantized decision-making methods were also conducted, referencing literature such as ["Comparison Between Viterbi Algorithm Soft And Hard Decision Decoding"](https://www.researchgate.net/publication/228758688_COMPARISON_BETWEEN_VITERBI_ALGORITHM_SOFT_AND_HARD_DECISION_DECODING). Research and our own findings favored unquantized decision-making for superior performance, followed by soft-decision. However, unquantized had limited real-life application, and soft-decision posed implementation challenges within our project's timeline. As a result, we opted for hard-decision demodulation. 

The implementation mapped 4 possible states of 2-bit inputs to a 7-bit bus representing ±1, incorporating a lookup table for signal demodulation. This 7-bit bus accommodates potential overflow from Gaussian noise while adhering to the 16-bit channel constraints (8-bit real, 8-bit imaginary).

## Potencial Improvements
1. Implement soft decision decoding. Soft decision decoding involves evaluating the likelihood (often represented as log-likelihood ratios or LLRs) of each bit instead of making definitive assignments based on a threshold. It has demonstrated substantial error correction performance improvements in both our simulations and literature reviews.

2. Implement interleaving. While convolutional codes are effective against random errors, they can be challenged by burst errors (consecutive errors within a short span). Interleaving can distribute burst errors throughout the data stream, making them appear as random errors to the decoder, thereby enhancing error correction capabilities.

# Postscript
If you intend to reference this project for your course, please include an appropriate citation. Thank you!

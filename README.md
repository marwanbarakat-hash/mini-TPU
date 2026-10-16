# 🚀 4x4 Weight-Stationary Tensor Processing Unit (TPU)

An ASIC-oriented, 32-bit RISC-styled **Weight-Stationary Tensor Processing Unit (TPU)** designed in SystemVerilog. Features a $4 \times 4$ Systolic Processing Element (PE) Grid, on-chip Scratchpad SRAM, an HBM-to-SRAM DMA Controller, skewing/unskewing delay buffers, a Vector Processing Unit (VPU) for ReLU activation and bias addition, and a dedicated 32-bit ISA.


## 📌 System Architecture

The TPU implements a 3-tier memory hierarchy: off-chip High-Bandwidth Memory (HBM), on-chip Scratchpad SRAM, and PE-internal registers (`wgt_reg`). Data width transformation (256-bit to 32-bit) is handled dynamically by the DMA Controller.

### High-Level Block Schematic

```mermaid
graph TB
    subgraph OFF_CHIP["Off-Chip Domain"]
        HBM["HBM Memory Controller<br/>(256-bit Wide Bus)"]
    end

    subgraph CONTROL_DOMAIN["Control Domain"]
        FSM["Main Control FSM & ISA Decoder<br/>(Instruction Register & Sequencer)"]
    end

    subgraph MEMORY_HIERARCHY["On-Chip Memory Domain"]
        DMA["DMA Controller / Bus Bridge<br/>(256b ↔ 32b Gearbox)"]
        SRAM["Scratchpad SRAM<br/>(64K x 32-bit Single-Port)"]
    end

    subgraph COMPUTE_ENGINE["Matrix Execution Pipeline Engine"]
        SKEW["Skewing Delay Buffer<br/>(+0, +1, +2, +3 Cycles)"]
        MXU["4x4 PE Matrix Execution Unit<br/>(16 x INT8 PEs with INT32 Acc)"]
        UNSKEW["Unskewing Delay Buffer<br/>(+3, +2, +1, +0 Cycles)"]
        VPU["Vector Processing Unit<br/>(Bias Add / ReLU / Quantizer)"]
    end

    %% Data Paths (Solid Bus Lines)
    HBM ==>|"hbm_data_out(255:0)"| DMA
    DMA ==>|"hbm_data_in(255:0)"| HBM
    DMA ==>|"sram_data_in(31:0)"| SRAM
    SRAM ==>|"sram_data_out(31:0)"| DMA
    
    SRAM ==>|"act_vec(31:0)"| SKEW
    SRAM ==>|"wgt_vec(31:0) - 4 cycles"| MXU
    SKEW ==>|"staggered_act(31:0)"| MXU
    
    MXU ==>|"acc_south(127:0)"| UNSKEW
    UNSKEW ==>|"aligned_acc(31:0)"| VPU
    VPU ==>|"post_proc_data(31:0)"| SRAM

    %% Control Paths & Handshakes (Dashed Lines)
    HBM -.->|"hbm_ready"| DMA
    DMA -.->|"dma_done"| FSM
    FSM -.->|"dma_start / hbm_addr(31:0)"| DMA
    FSM -.->|"sram_addr(15:0) / rd_en / wr_en"| SRAM
    FSM -.->|"load_wgt (1-cycle pulse)"| MXU
    FSM -.->|"vpu_mode(3:0) / vpu_en"| VPU

    %% Hardware Textbook Styling (Black & White Wireframe Theme)
    classDef hwStyle fill:#ffffff,stroke:#000000,stroke-width:2px,color:#000000;
    
    class HBM,FSM,DMA,SRAM,SKEW,MXU,UNSKEW,VPU hwStyle;
    
    linkStyle default stroke:#000000,stroke-width:2px;
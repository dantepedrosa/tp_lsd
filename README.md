# Digital Clock & Stopwatch FPGA Project

## Overview

Este projeto implementa um **relógio digital e cronômetro** para FPGA (DE2), com suporte a ajuste de horas e minutos e funcionalidade de blink nos displays ao ajustar o relógio. A interface é composta por **teclas de entrada (KEY[0..2])** e **displays de 7 segmentos (HEX0 a HEX3)**. A lógica de controle é baseada em uma **máquina de estados finita (FSM)** que gerencia os modos de relógio e cronômetro.

---

## Estrutura de Arquivos
```
.
├── include
│ ├── auxiliary_clock.vhd   # Gera pulsos de 1 segundo e 1 minuto a partir do clock de 50 MHz
│ ├── counter.vhd           # Contador genérico com CLEAR, CLK, COUNT, saída Q e COUT
│ ├── decoder.vhd           # Decodificador BCD -> 7 segmentos
│ ├── fsm.vhd               # Máquina de estados que controla modos, ajustes e cronômetro
│ ├── mux_2x1.vhd           # Multiplexador 2x1 genérico para BCD
│ ├── mux_display_blink.vhd # Multiplexador que implementa blink nos dígitos ajustáveis
│ ├── mux_display.vhd       # Multiplexador simples entre relógio e cronômetro
│ ├── stopwatch.vhd         # Cronômetro com contagem de segundos e minutos
│ └── watch.vhd             # Relógio com contagem de horas e minutos
├── src
│ └── top.vhd               # Top-level, instancia FSM, relógio, cronômetro e displays
└── test
├── tb_fsm.vhd              # Testbench da FSM, cobre transições de modo, ajustes e reset
├── tb_stpwtch.vhd          # Testbench do cronômetro
└── tb_watch.vhd            # Testbench do relógio
```

---

## Funcionalidades Principais

- **Relógio digital**: contagem de horas e minutos, ajuste de hora e minuto com blink nos dígitos ajustáveis.  
- **Cronômetro**: inicia/parada/reset, contagem de segundos e minutos.  
- **Blink**: indica dígitos selecionados para ajuste.  
- **Displays de 7 segmentos**: mostram tanto o relógio quanto o cronômetro via multiplexação.  
- **Máquina de estados finita (FSM)**: gerencia modos de operação e habilitação de ajustes.

---

## Notas de Síntese

- Os arquivos em `include` contêm **blocos modulares reutilizáveis** (contadores, decodificador, multiplexadores).  
- O `top.vhd` conecta todos os módulos e é **pronto para síntese em FPGA**.  
- Os testbenches em `test` permitem simulação de cada módulo separadamente ou do sistema completo.
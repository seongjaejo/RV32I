# RV32I Single-Cycle CPU

RISC-V RV32I Base Integer ISA 기반의 Single-Cycle CPU를 SystemVerilog로 설계한 개인 프로젝트입니다.
Control Unit과 Datapath를 분리한 구조로 9종 Instruction Type, 37개 명령어를 구현했고,
C 코드로 작성한 0~10 누적합 프로그램을 Assembly로 변환해 실행해 최종 결과 `data_ram[58] = 55`를 확인했습니다.

- **Top module**: `top_rv32i_soc`
- **언어**: SystemVerilog
- **진행**: 경기도팹리스아카데미 온디바이스AI 시스템반도체 설계 2기 (2026.05)

## 주요 내용

| 항목 | 내용 |
|---|---|
| 명령어 | R / I / IL(Load) / S(Store) / B(Branch) / LUI / AUIPC / JAL / JALR, 총 37개 |
| 구조 | Control Unit · Datapath 분리, Register File / ALU / Immediate Extend / PC Logic / Write-Back MUX |
| ALU 제어 | `{funct7[5], funct3}` 4-bit `alu_control`로 R/I-type ALU 연산 통합 |
| 부호 처리 검증 | SLT/SLTU, SRL/SRA처럼 부호 처리에 따라 결과가 갈리는 명령어를 신호 단위로 비교 |
| 프로그램 실행 | Stack Frame 생성·해제(sp 256 → 224 → 192 → 224), LUI+ADDI 32-bit 상수 생성, 누적합 55 확인 |

## 검증 실행

Icarus Verilog 13과 Python이 필요합니다. 저장소 루트에서 실행합니다.
`instruction_code.mem`은 시뮬레이터 실행 폴더에 배치합니다.

```sh
python verification/run_checks.py
```

실행한 테스트와 로그는 `verification/`에 있습니다.
테스트 범위와 알려진 제한은 [검증 기록](SELECTION_AND_VALIDATION.md)에 정리했습니다.
이 저장소의 검증은 시뮬레이션 기준이며, 실물 보드 동작·합성·타이밍 검증 완료를 의미하지 않습니다.

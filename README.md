# RV32I Single-Cycle CPU

선정 원본: `D:\OndeviceAI2\20260519_RV32I`

Top: `top_rv32i_soc`

instruction_code.mem을 시뮬레이터 실행 폴더에 배치합니다. SUM 결과 55를 원본 그대로 확인했습니다.

선정 근거와 실제 테스트 범위·알려진 제한은 [검증 기록](SELECTION_AND_VALIDATION.md)을 확인하세요.

## 검증 실행

Icarus Verilog 13과 Python이 필요합니다. 저장소 루트에서 실행합니다.

```sh
python verification/run_checks.py
```

실행한 테스트와 로그는 `verification/`에 있습니다. 실물 보드 재시험·합성·타이밍 검증 완료를 의미하지 않습니다.

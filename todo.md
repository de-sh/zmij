# zmij.zig Improvement TODOs

## Completed

- [x] Fix broken benchmark (`bench.zig`) - uses `zmij.dtoa`/`zmij.Buffer` instead of `zmij.writer`/`zmij.Formatter`
- [x] Use `std.debug.assert` instead of `if (!cond) unreachable` (lines 654, 810, 818)
- [x] Remove redundant `@as(u64, ...)` cast in `digits2U64` (line 704)
- [x] Use `@This()` instead of `Formatter(T)` (line 1015)
- [x] Replace `var pos: usize = undefined` with block-initialized `var` in `write()` (line 764)
- [x] Add `std.fmt` integration via `fmtFloat()` wrapper (uses `{f}` format specifier)
- [x] Make `implicit_bit` use type `U` instead of always `u64` (line 955)
- [x] Use type annotation instead of `@as` in test (test.zig:60)

## Bug fixes discovered by ported tests

- [x] Fix f32 `Formatter` buffer overflow: buffer was 16 bytes but f32 can produce up to 24 chars (matched Rust's 24-byte buffer)
- [x] Fix `@intCast` → `@bitCast` in `toDecimalSchubfach` (line 879): wrapping subtraction needs bitwise reinterpret, not checked cast (Rust uses `as i64`)
- [x] Fix `@clz` in small-integer path (line 988): hardcoded `63` assumes u64 but `f` is u32 for f32; widen to `@clz(@as(u64, f))`

## Ported from Rust

- [x] Port `subnormal` test (5 f64 subnormal values)
- [x] Port `normal` half-ulp tie case
- [x] Port `all_irregular` test (1022 binade-boundary values)
- [x] Port `all_exponents` test (1024 exponent values)
- [x] Port `f32_normal` test (3 cases)
- [x] Port `f32_subnormal` test
- [x] Port random f64 round-trip stress test (100K iterations)
- [x] Port random f32 round-trip stress test (100K iterations)
- [x] Port exhaustive f32 round-trip test (`zig build test-exhaustive`)
- [x] Rewrite benchmark with Rust-matching values (0, 0.1234, 0.123456789, e, max, pi, 1e-20, 1.23e300) + warmup

## Skipped

- [ ] Make `exp_mask` unsigned (line 961) - derives from `i32` typed `num_exp_bits`, change would cascade

## Known algorithm issues (exposed by new tests)

- [x] 28/1022 binade-boundary f64 values don't round-trip correctly — fixed by adding pow10 overestimate adjustment in `toDecimalSchubfach`
- [x] ~1/100K random f64 values have round-trip failures — fixed by pow10 overestimate adjustment
- [x] ~2/100K random f32 values have round-trip failures — fixed by skipping f32 fast path (constants were f64-only)
- [x] f64 subnormals format as e.g. `0.000000000000005e-309` instead of `5e-324` — fixed by removing early return in `normalizeSig` for u64
- [x] Some f32 values produce un-normalized output like `0.00000001342178e16` instead of `1.342178e8` — fixed by skipping f32 fast path

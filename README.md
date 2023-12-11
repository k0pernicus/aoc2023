# AOC 2023

Usage of **swift 5.9**

## Build

In root folder:
1. `swift build -c release`
2. `./build/<arch>/<profile>/aoc2023 -i inputs/01.txt 01`

For more information:
`swift run --help`

## Testing

In root folder:
1. `swift test --filter DayTests.<DayTestToRun>`

## Notes

Day05 Part 02 will take some time to compute the answer, as I did not (yet) implement the optimized version but only the bruteforce method.

// ビルド:
//    $ go build hoshimeguri1.go
//
// 実行:
//    $ ./hoshimeguri1 ../data.txt

package main

import (
  "bytes"
  "bufio"
  "fmt"
  "os"
  "strings"
)

func solve(input string) string {
  star := map[byte] map[rune] byte {
    'A': {'W': 'I', 'R': 'H'},
    'I': {'W': 'G', 'R': 'F'},
    'G': {'W': 'E', 'R': 'D'},
    'E': {'W': 'C', 'R': 'B'},
    'C': {'W': 'A', 'R': 'J'},
    'H': {'W': 'C', 'R': 'J'},
    'J': {'W': 'E', 'R': 'B'},
    'B': {'W': 'G', 'R': 'D'},
    'D': {'W': 'I', 'R': 'F'},
    'F': {'W': 'A', 'R': 'H'}}
  point := input[0]
  result := bytes.NewBufferString("")
  result.WriteByte(point)
  for _, c := range input[1:] {
    point = star[point][c]
    result.WriteByte(point)
  }
  return result.String()
}

func test(input string, expected string) {
  actual := solve(input)
  if actual == expected {
    fmt.Print(".")
  } else {
    fmt.Printf(`
input:    %s
expected: %s
actual:   %s
`, input, expected, actual)
  }
}

func main() {
  filename := os.Args[1]
  file, _ := os.Open(filename)
  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    tokens := strings.Split(scanner.Text(), " ")
    test(tokens[0], tokens[1])
  }
  file.Close()
  fmt.Println()
}

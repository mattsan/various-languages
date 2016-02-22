//  ビルド:
//    $ go build hoshimeguri2.go
//
//  実行:
//    $ ./hoshimeguri2 ../data.txt

package main

import (
  "bufio"
  "bytes"
  "fmt"
  "os"
  "strings"
)

const points = "AHCJEBGDIF"

type Star struct {
  indices []int
}

func NewStar(c byte) Star {
  return Star { indices: []int{strings.IndexByte(points, c)} }
}

func (star *Star) Step(c rune) Star {
  index := star.indices[len(star.indices) - 1]
  switch struct{int; rune}{index % 2, c} {
    case struct {int; rune}{1, 'R'}: index = (index + 2) % 10
    case struct {int; rune}{0, 'W'}: index = (index + 8) % 10
    default:                         index = (index + 1) % 10
  }
  star.indices = append(star.indices, index)
  return *star
}

func (star *Star) String() string {
  result := bytes.NewBufferString("")
  for _, index := range star.indices {
    result.WriteByte(points[index])
  }
  return result.String()
}

func solve(input string) string {
  star := NewStar(input[0])
  for _, c := range input[1:] {
    star.Step(c)
  }
  return star.String()
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

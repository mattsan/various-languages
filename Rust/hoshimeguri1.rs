//  ビルド:
//    $ rustc hoshimeguri1.rs
//
//  実行:
//    $ ./hoshimeguri1 ../data.txt

fn star(p: char, c: char) -> char {
    match (p, c) {
        ('A', 'W') => 'I',
        ('A', 'R') => 'H',
        ('I', 'W') => 'G',
        ('I', 'R') => 'F',
        ('G', 'W') => 'E',
        ('G', 'R') => 'D',
        ('E', 'W') => 'C',
        ('E', 'R') => 'B',
        ('C', 'W') => 'A',
        ('C', 'R') => 'J',
        ('H', 'W') => 'C',
        ('H', 'R') => 'J',
        ('J', 'W') => 'E',
        ('J', 'R') => 'B',
        ('B', 'W') => 'G',
        ('B', 'R') => 'D',
        ('D', 'W') => 'I',
        ('D', 'R') => 'F',
        ('F', 'W') => 'A',
        ('F', 'R') => 'H',
        _          => '_'
    }
}

fn solve(input: &str) -> String {
    let mut colors = input.chars();
    let mut p = colors.next().unwrap();
    let mut output = String::new();
    output.push(p);
    for c in colors {
        p = star(p, c);
        output.push(p)
    }
    output
}

fn test(input: &str, expected: &str) {
    let actual = solve(input);
    if actual == expected {
        print!(".")
    } else {
      println!(r#"
input:    {}
expected: {}
actual:   {}"#, input, expected, actual)
    }
}

fn read_lines(filename: String, lines: &mut Vec<String>) -> std::io::Result<()> {
    use std::io::prelude::*;
    use std::fs::File;
    let mut file = try!(File::open(filename));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    for line in contents.lines() {
        lines.push(line.to_string())
    }
    Ok(())
}

fn main() {
    use std::env;

    let mut args = env::args();

    match args.nth(1) {
        Some(filename) => {
            let mut lines: Vec<String> = Vec::new();
            read_lines(filename, &mut lines);
            for line in lines {
                let mut words = line.split_whitespace();
                let input = words.next();
                let expected = words.next();
                test(input.unwrap(), expected.unwrap())
            }
        }
        None => println!("no file")
    }
    println!("")
}

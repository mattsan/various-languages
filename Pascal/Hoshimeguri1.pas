{
  ビルド:
    $ fpc Hoshimeguri1

  実行:
    $ ./Hoshimeguri1 ../data.txt
}

program Hoshimeguri1;
{$mode objfpc}

uses
  Classes, SysUtils;

function Star(Point: Char; Color: Char): Char;
begin
  case Point of
    'A':
        case Color of
          'W': Star := 'I';
          'R': Star := 'H'
        end;
    'I':
      case Color of
        'W': Star := 'G';
        'R': Star := 'F'
      end;
    'G':
      case Color of
        'W': Star := 'E';
        'R': Star := 'D'
      end;
    'E':
      case Color of
        'W': Star := 'C';
        'R': Star := 'B'
      end;
    'C':
      case Color of
        'W': Star := 'A';
        'R': Star := 'J'
      end;
    'H':
      case Color of
        'W': Star := 'C';
        'R': Star := 'J'
      end;
    'J':
      case Color of
        'W': Star := 'E';
        'R': Star := 'B'
      end;
    'B':
      case Color of
        'W': Star := 'G';
        'R': Star := 'D'
      end;
    'D':
      case Color of
        'W': Star := 'I';
        'R': Star := 'F'
      end;
    'F':
      case Color of
        'W': Star := 'A';
        'R': Star := 'H'
      end
  end
end;

function Solve(Input: String): String;
var
  I: Integer;
  Color: Char;
  Point: Char;
begin
  Point := Input[1];
  Solve := Point;
  for I := 2 to length(Input) do
  begin
    Point := Star(Point, Input[I]);
    Solve := Solve + Point
  end;
end;

procedure Test(Input: String; Expected: String);
var
  Actual: String;
begin
  Actual := Solve(Input);
  if Actual = Expected then
    Write('.')
  else
  begin
    WriteLn;
    WriteLn('input:    ', Input);
    WriteLn('expected: ', Expected);
    WriteLn('actual:   ', Actual)
  end
end;

var
  DataFile: TextFile;
  Line: String;
  StringList: TStringList;
begin
  AssignFile(DataFile, ParamStr(1));
  Reset(DataFile);
  try
    StringList := TStringList.Create;
    try
      while not Eof(DataFile) do
      begin
        ReadLn(DataFile, Line);
        Stringlist.DelimitedText := Line;
        Test(StringList[0], StringList[1])
      end
    finally
      StringList.Free
    end
  finally
    CloseFile(DataFile)
  end;
  WriteLn
end.

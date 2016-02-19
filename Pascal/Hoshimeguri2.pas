(*
  $ fpc Hoshimeguri2
  $ ./Hoshimeguri2 ../data.txt
*)
program Hoshimeguri2;
{$mode objfpc}

uses
  Classes, SysUtils, Solver2;

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

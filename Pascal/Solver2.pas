unit Solver2;
{$mode objfpc}

interface

function Solve(Input: String): String;

implementation

function Solve(Input: String): String;

  function Step(Point: Integer; Color: Char): Integer;
  begin
    case Point mod 2 of
      1:
        case Color of
          'R': Result := (Point + 2) mod 10;
          else Result := (Point + 1) mod 10
        end;
      0:
        case Color of
          'W': Result := (Point + 8) mod 10;
          else Result := (Point + 1) mod 10
        end
    end
  end;

const
  Points = 'AHCJEBGDIF';
var
  I: Integer;
  Index: Integer;
begin
  Result := Input[1];
  Index := Pos(Input[1], Points) - 1;
  for I := 2 to length(Input) do
  begin
    Index := Step(Index, Input[I]);
    Result := Solve + Points[Index + 1]
  end;
end;

end.

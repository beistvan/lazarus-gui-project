unit filekezeles9fo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { TFajlkezeles9 }

  TLajhar = record
    nev: string;
    eletkor: integer;
    testtomeg: real;
    nem: string;
    utod: integer;
  end;

  TFajlkezeles9 = class(TForm)
    Feladat1Gomb: TButton;
    Feladat2Gomb: TButton;
    Feladat3Gomb: TButton;
    Feladat4Gomb: TButton;
    TorlesGomb: TButton;
    Feladat1Felirat: TLabel;
    Feladat2Felirat: TLabel;
    Feladat3Felirat: TLabel;
    Feladat4Felirat: TLabel;
    LajharTabla: TStringGrid;
    TombFeltoltese: TButton;
    FileBeolvasasa: TButton;
    FeladatSzovege: TMemo;
    Filetartalom: TMemo;
    procedure Feladat1GombClick(Sender: TObject);
    procedure Feladat2GombClick(Sender: TObject);
    procedure Feladat3GombClick(Sender: TObject);
    procedure Feladat4GombClick(Sender: TObject);
    procedure TorlesGombClick(Sender: TObject);
    procedure FileBeolvasasaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TombFeltolteseClick(Sender: TObject);
  private

  public

  end;

var
  Fajlkezeles9: TFajlkezeles9;

const FILENEV = 'lajharok.txt';
const MAX_LAJHAR_SZAM = 10;

var lajharmennyiseg : byte;
    lajharok: array [1..MAX_LAJHAR_SZAM] of TLajhar;
implementation

{$R *.lfm}

{ TFajlkezeles9 }

procedure TFajlkezeles9.FormCreate(Sender: TObject);
begin
   DecimalSeparator := '.';
end;

procedure TFajlkezeles9.TombFeltolteseClick(Sender: TObject);
var index: Byte; A,B: TStringArray; t: string;
begin
   LajharTabla.RowCount:=1;
   for index := 0 to lajharmennyiseg - 1 do
   begin
       A := Filetartalom.Lines[index * 3].Split(';');
       lajharok[index + 1].nev := A[0];
       lajharok[index + 1].eletkor := StrToInt(A[1]);
       t := Filetartalom.Lines[index * 3 + 1];
       lajharok[index + 1].testtomeg := StrToFloat(t);
       B := Filetartalom.Lines[index * 3 + 2].Split(';');
       lajharok[index + 1].nem := B[0];
       lajharok[index + 1].utod := StrToInt(B[1]);
       LajharTabla.InsertRowWithValues(index + 1, [ A[0], A[1], t, B[0], B[1] ]);
   end;
end;

procedure TFajlkezeles9.FileBeolvasasaClick(Sender: TObject);
begin
   Filetartalom.Lines.LoadFromFile(FILENEV);
   lajharmennyiseg := Filetartalom.Lines.Count div 3;
end;

procedure TFajlkezeles9.Feladat1GombClick(Sender: TObject);
var index, darabszam: byte;
begin
   darabszam := 0;
   for index := 1 to lajharmennyiseg do
      if lajharok[index].nem = 'nosteny' then inc(darabszam);
   Feladat1Felirat.Caption:='Nőstény: '+inttostr(darabszam);
end;

procedure TFajlkezeles9.Feladat2GombClick(Sender: TObject);
var index, osszesenhimekkolyke: byte;
begin
   osszesenhimekkolyke := 0;
   for index := 1 to lajharmennyiseg do
      if lajharok[index].nem = 'him' then inc(osszesenhimekkolyke,lajharok[index].utod);
   Feladat2Felirat.Caption:='Hímek kölykei: '+inttostr(osszesenhimekkolyke);

end;

procedure TFajlkezeles9.Feladat3GombClick(Sender: TObject);
var i,j:integer; L:TLajhar;
begin
  for i := 1 to lajharmennyiseg - 1 do
    for j := i + 1 to lajharmennyiseg do
       if lajharok[i].eletkor > lajharok[j].eletkor then
       begin
         L := lajharok[i];
         lajharok[i] := lajharok[j];
         lajharok[j] := L;
       end;
  LajharTabla.RowCount:=1;
  for i := 1 to lajharmennyiseg do
     with lajharok[i] do
        LajharTabla.InsertRowWithValues(i, [nev, inttostr(eletkor), floattostr(testtomeg), nem, inttostr(utod)]);
  Feladat3Felirat.Caption := 'Rendezés: É';
end;

procedure TFajlkezeles9.Feladat4GombClick(Sender: TObject);
var i,j,db:integer;
begin
  db:=0;
  for i := 1 to lajharmennyiseg do
    if lajharok[i].utod>0 then
    begin
      j:=2;                            // tagadás: ( L1uh=L2un és ((L1=n és L2=h) vagy (L1=h és L2=n))  )
      while (j <= lajharmennyiseg) and
          ( (lajharok[i].utod <> lajharok[j].utod)
             or ( ( (lajharok[i].nem = 'nosteny') or (lajharok[j].nem = 'him') )
                  and ( (lajharok[i].nem = 'him') or (lajharok[j].nem = 'nosteny') )
                )
          ) do
        inc(j);
      if j<=lajharmennyiseg then
        inc(db);
    end;
  Feladat4Felirat.caption:='Sikeres pár: ' + inttostr( (db div 2) );
end;

procedure TFajlkezeles9.TorlesGombClick(Sender: TObject);
begin
   Filetartalom.Text:='';
   LajharTabla.RowCount:=1;
   Feladat1Felirat.Caption:='Nőstény:';
   Feladat2Felirat.Caption:='Hímek kölykei:';
   Feladat3Felirat.Caption := 'Rendezés';
   Feladat4Felirat.caption:='Sikeres pár:';
end;



end.


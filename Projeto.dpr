program Projeto;

uses
  Vcl.Forms,
  Uprinc in 'Uprinc.pas' {Fprinc},
  Umodulo in 'Umodulo.pas' {Dm: TDataModule},
  Ucadunimed in 'Ucadunimed.pas' {Fcadunimed},
  Ucadunimed2 in 'Ucadunimed2.pas' {Fcadunimed2},
  Ucadprod in 'Ucadprod.pas' {fcadprod},
  Ufcadprod2 in 'Ufcadprod2.pas' {fcadprod2},
  UPesqcad in 'UPesqcad.pas' {FPesqcad},
  UFrelprod in 'UFrelprod.pas' {FFrelprod};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TFprinc, Fprinc);
  Application.CreateForm(TFFrelprod, FFrelprod);
  Application.Run;
end.

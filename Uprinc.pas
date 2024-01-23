unit Uprinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TFprinc = class(TForm)
    MainMenu1: TMainMenu;
    Cadastrodeunidademedida1: TMenuItem;
    UnidadeMedida1: TMenuItem;
    Sair1: TMenuItem;
    CadastrodeProduto1: TMenuItem;
    procedure UnidadeMedida1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure CadastrodeProduto1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fprinc: TFprinc;

implementation

{$R *.dfm}

uses Ucadunimed, Ucadprod;

procedure TFprinc.CadastrodeProduto1Click(Sender: TObject);
begin
     try
          Application.CreateForm(Tfcadprod, fcadprod);
          fcadprod.ShowModal;
     finally
          FreeAndNil(fcadprod);
     end;
end;

procedure TFprinc.Sair1Click(Sender: TObject);
begin
     Close;
end;

procedure TFprinc.UnidadeMedida1Click(Sender: TObject);
begin
     try
          Application.CreateForm(TFcadunimed, Fcadunimed);
          Fcadunimed.ShowModal;
     finally
          FreeAndNil(Fcadunimed);
     end;
end;

end.

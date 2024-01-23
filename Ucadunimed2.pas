unit Ucadunimed2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.DBCtrls, Data.FMTBcd, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.SqlExpr;

type
  TFcadunimed2 = class(TForm)
    Panel1: TPanel;
    btSalvar: TSpeedButton;
    BtCancelar: TSpeedButton;
    Label3: TLabel;
    edCod: TDBEdit;
    Label2: TLabel;
    sdsunimed: TSQLDataSet;
    Dpsunimed: TDataSetProvider;
    cdsunimed: TClientDataSet;
    Dsunimed: TDataSource;
    cdsunimedCODUNIMED: TIntegerField;
    cdsunimedDESCRICAO: TStringField;
    Eddescricao: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var_incluse : Boolean;
    procedure novo;
    procedure alterar;
    procedure deletar;
  end;

var
  Fcadunimed2: TFcadunimed2;


implementation

{$R *.dfm}

uses Ucadunimed, Umodulo;

procedure TFcadunimed2.BtCancelarClick(Sender: TObject);
begin
     if Application.MessageBox('Deseja realmente cancelar?', 'Aten��o', mb_YesNo + MB_ICONQUESTION ) = IdYes then
     begin
          cdsunimed.CancelUpdates;
          cdsunimed.Cancel;
          close;
     end;
end;

procedure TFcadunimed2.btSalvarClick(Sender: TObject);
begin
     if Trim(eddescricao.Text) = '' then
     begin
          Application.MessageBox('Descri��o n�o pode ser vazio!','Aten��o',MB_ICONEXCLAMATION);
          eddescricao.SetFocus;
          Abort;
     end;

      try
          cdsunimed.ApplyUpdates(0);
     except
          On e: Exception do
          begin
                Application.MessageBox( PWideChar(WideString('Erro ao salvar. ' + #13 + ' Mensagem original: ' + e.Message)), 'Aten��o', MB_ICONEXCLAMATION);
                Abort;
          end;
     end;
     Close;
end;

procedure TFcadunimed2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     cdsunimed.Close;
end;

procedure TFcadunimed2.FormCreate(Sender: TObject);
begin
     cdsunimed.Open;
end;

procedure TFcadunimed2.FormShow(Sender: TObject);
begin
     If var_incluse = true then
          novo
     Else alterar;
end;

procedure TFcadunimed2.novo;
begin
     cdsunimed.Append;

     // BUSCA O ULTIMO NUMERO DO CADASTRO
     cdsunimedCODUNIMED.AsInteger := proximoId('GEN_ID_UNIMED');
     eddescricao.SetFocus;
end;

procedure TFcadunimed2.alterar;
begin
     cdsunimed.Edit;
     eddescricao.SetFocus;
end;

procedure TFcadunimed2.deletar;
begin
      cdsunimed.Delete;
      cdsunimed.ApplyUpdates(0);
      cdsunimed.Close;
end;

end.

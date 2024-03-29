unit Ufcadprod2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.DBCtrls, Data.FMTBcd, Data.DB, Datasnap.Provider,
  Datasnap.DBClient, Data.SqlExpr;

type
  Tfcadprod2 = class(TForm)
    Panel1: TPanel;
    btSalvar: TSpeedButton;
    BtCancelar: TSpeedButton;
    Label3: TLabel;
    edCod: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Eddescricao: TDBEdit;
    Edcoduni: TDBEdit;
    btcadmedida: TBitBtn;
    btpesmedida: TBitBtn;
    Edvalor: TDBEdit;
    Eddescuni: TDBEdit;
    sdsprod: TSQLDataSet;
    cdsprod: TClientDataSet;
    Dpsprod: TDataSetProvider;
    Dsprod: TDataSource;
    cdsprodCODIGO: TIntegerField;
    cdsprodDESCRICAO: TStringField;
    cdsprodVALOR: TFMTBCDField;
    cdsprodCODUNMED: TIntegerField;
    cdsprodcal_descunimed: TStringField;
    sqlcon: TSQLQuery;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btcadmedidaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btpesmedidaClick(Sender: TObject);
    procedure EdcoduniKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdcoduniExit(Sender: TObject);
    procedure cdsprodCalcFields(DataSet: TDataSet);
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
    function BuscaRegistro(codigo : string ) : String;
  end;

var
  fcadprod2: Tfcadprod2;

implementation

{$R *.dfm}

uses Umodulo, Ucadprod, Ucadunimed, UPesqcad;

procedure Tfcadprod2.btcadmedidaClick(Sender: TObject);
begin
      Application.CreateForm(TFcadunimed, Fcadunimed);
      Fcadunimed.ShowModal;
      FreeAndNil(Fcadunimed);
end;

procedure Tfcadprod2.BtCancelarClick(Sender: TObject);
begin
     if Application.MessageBox('Deseja realmente cancelar?', 'Aten��o', mb_YesNo + MB_ICONQUESTION ) = IdYes then
     begin
          cdsprod.CancelUpdates;
          cdsprod.Cancel;
          close;
     end;
end;

procedure Tfcadprod2.btpesmedidaClick(Sender: TObject);
var  sql : String;
begin
     sql := ' SELECT CODUNIMED, DESCRICAO ';
     sql := sql + ' FROM TBUNIMED ';

     application.createform(tfpesqcad,fpesqcad);

     FPesqcad.cdspesqcad.indexfieldnames := '';
     FPesqcad.cdspesqcad.Close;
     FPesqcad.cdspesqcad.CommandText := sql;
     FPesqcad.cdspesqcad.Open;
     FPesqcad.cdspesqcad.indexfieldnames := 'DESCRICAO';

     fpesqcad.dbgpes.columns.rebuildcolumns;
     fpesqcad.dbgpes.columns[0].fieldname := 'CODUNIMED';
     fpesqcad.dbgpes.columns[0].title.Caption := 'C�digo';
     fpesqcad.dbgpes.columns[1].fieldname := 'DESCRICAO';
     fpesqcad.dbgpes.columns[1].title.Caption := 'Descri��o';
     fpesqcad.edpes.Text := '';
     fpesqcad.edpes.Text := Eddescuni.Text;
     fpesqcad.lbpes.Caption := 'Descri��o:';
     fpesqcad.Caption  := 'Pesquisa de Unidade Medida';
     fpesqcad.ShowModal();

     if fpesqcad.tag = 1 then
     begin
          cdsprodCODUNMED.AsInteger     := StrToInt(fpesqcad.cdspesqcad['CODUNIMED']);
          cdsprodcal_descunimed.AsString := fpesqcad.cdspesqcad['DESCRICAO'];
     end;

     FreeAndNil(fpesqcad);
     Edcoduni.SetFocus;
end;

procedure Tfcadprod2.btSalvarClick(Sender: TObject);
begin
     if Trim(cdsprodDESCRICAO.AsString) = '' then
     begin
          Application.MessageBox('Descri��o n�o pode ser vazio!','Aten��o',MB_ICONEXCLAMATION);
          eddescricao.SetFocus;
          Abort;
     end;

     if cdsprodVALOR.AsCurrency <= 0 then
     begin
          Application.MessageBox('Valor inv�lido!','Aten��o',MB_ICONEXCLAMATION);
          Edvalor.SetFocus;
          Abort;
     end;

      if Trim(cdsprodCODUNMED.AsString) = '' then
     begin
          Application.MessageBox('Unidade de medida n�o pode ser vazio!','Aten��o',MB_ICONEXCLAMATION);
          eddescricao.SetFocus;
          Abort;
     end;

     sqlcon.Close;
     sqlcon.SQL.Text := 'select DESCRICAO from TBUNIMED where CODUNIMED = '+ Edcoduni.Text ;
     sqlcon.Open;

     if not (sqlcon.isempty) then
          Eddescuni.Text := sqlcon['descricao']
     else
     begin
          Application.MessageBox( PWideChar('C�digo n�o encontrado !' + #13 + 'Pressione a tecla <F5> para abrir a consulta !'), 'Aten��o', MB_ICONEXCLAMATION);
          Edcoduni.SetFocus;
          Abort;
     end;

      try
          cdsprod.ApplyUpdates(0);
     except
          On e: Exception do
          begin
                Application.MessageBox( PWideChar(WideString('Erro ao salvar. ' + #13 + ' Mensagem original: ' + e.Message)), 'Aten��o', MB_ICONEXCLAMATION);
                Abort;
          end;
     end;
     Close;

end;

procedure Tfcadprod2.cdsprodCalcFields(DataSet: TDataSet);
begin
     cdsprodcal_descunimed.AsString := BuscaRegistro(cdsprodCODUNMED.AsString);
end;

procedure Tfcadprod2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     cdsprod.Close;
     sqlcon.Close;
end;

procedure Tfcadprod2.FormCreate(Sender: TObject);
begin
     cdsprod.Open;
end;

procedure Tfcadprod2.FormKeyPress(Sender: TObject; var Key: Char);
begin
     if (Key = #13) and not (ActiveControl is TMemo) then
     begin
          Perform(WM_NEXTDLGCTL,0,0);
     end;
end;

procedure Tfcadprod2.FormShow(Sender: TObject);
begin
     If var_incluse = true then
          novo
     Else alterar;
end;

procedure Tfcadprod2.novo;
begin
     cdsprod.Append;

     // BUSCA O ULTIMO NUMERO DO CADASTRO
     cdsprodCODIGO.AsInteger := proximoId('GEN_ID_PROD');
     Eddescricao.SetFocus;
end;

procedure Tfcadprod2.alterar;
begin
     cdsprod.Edit;
     eddescricao.SetFocus;
end;

procedure Tfcadprod2.deletar;
begin
      cdsprod.Delete;
      cdsprod.ApplyUpdates(0);
      cdsprod.Close;
end;

procedure Tfcadprod2.EdcoduniExit(Sender: TObject);
begin
     if cdsprod.State in [dsInactive,dsBrowse] then exit;

     if Trim(Edcoduni.Text) = '' then Exit;

     sqlcon.Close;
     sqlcon.SQL.Text := 'select DESCRICAO from TBUNIMED where CODUNIMED = '+ Edcoduni.Text ;
     sqlcon.Open;

     if not (sqlcon.isempty) then
          Eddescuni.Text := sqlcon['descricao']
     else
     begin
          Application.MessageBox( PWideChar('C�digo n�o encontrado !' + #13 + 'Pressione a tecla <F5> para abrir a consulta !'), 'Aten��o', MB_ICONEXCLAMATION);
          Edcoduni.SetFocus;
          Abort;
     end;

end;

procedure Tfcadprod2.EdcoduniKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = 116 then
          btpesmedida.onclick(self);
end;

function Tfcadprod2.BuscaRegistro(codigo : string ) : String;
var
 sql : String;
 qrySelect : TSQLQuery;
begin
     if codigo = '' then exit;
     
     sql := ' select DESCRICAO';
     sql := sql + ' From TBUNIMED';
     sql := sql + ' where CODUNIMED = ' +codigo;

     qrySelect := TSQLQuery.Create(nil);
     qrySelect.SQLConnection := dm.conexao;
     qrySelect.SQL.Clear;
     qrySelect.SQL.Add(sql);
     qrySelect.Open;

     result := qrySelect.FieldByName('DESCRICAO').AsString;

     FreeAndNil(qrySelect);
end;

end.

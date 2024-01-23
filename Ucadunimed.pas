unit Ucadunimed;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Data.FMTBcd, Data.SqlExpr,
  Datasnap.Provider, Datasnap.DBClient;

type
  TFcadunimed = class(TForm)
    Panel1: TPanel;
    btIncluir: TSpeedButton;
    btAlterar: TSpeedButton;
    btExcluir: TSpeedButton;
    btSair: TSpeedButton;
    Panel2: TPanel;
    Label1: TLabel;
    btLimparFiltro: TSpeedButton;
    edPes: TEdit;
    Dbunimed: TDBGrid;
    dsconsulta: TDataSource;
    cdsconsulta: TClientDataSet;
    dspconsulta: TDataSetProvider;
    sdsconsulta: TSQLDataSet;
    cdsconsultaCODUNIMED: TIntegerField;
    cdsconsultaDESCRICAO: TStringField;
    procedure btSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure DbunimedDrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DbunimedTitleClick(Column: TColumn);
    procedure btLimparFiltroClick(Sender: TObject);
    procedure edPesChange(Sender: TObject);
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
  private
    { Private declarations }
     colsel : String;
  public
    { Public declarations }
  end;

var
  Fcadunimed: TFcadunimed;

implementation

{$R *.dfm}

uses Umodulo, Ucadunimed2;

procedure TFcadunimed.btAlterarClick(Sender: TObject);
begin
     if cdsconsulta.IsEmpty then EXIT;

     Application.CreateForm(TFcadunimed2, Fcadunimed2);
     Fcadunimed2.var_incluse := False;
     Fcadunimed2.ShowModal;
     FreeAndNil(Fcadunimed2);
     cdsconsulta.Refresh;
end;

procedure TFcadunimed.btExcluirClick(Sender: TObject);
begin
     if cdsconsulta.IsEmpty then EXIT;

     if cdsconsulta.State in [dsBrowse] then
     begin
          if Application.MessageBox('Deseja realmente excluir registro selecionado ?', 'Aten��o', mb_YesNo + MB_ICONQUESTION ) = IdYes then
          begin
               Application.CreateForm(TFcadunimed2, Fcadunimed2);
               Fcadunimed2.deletar;
               FreeAndNil(Fcadunimed2);
               cdsconsulta.Refresh;
               cdsconsulta.Refresh
          end;
     end
     else
          Application.MessageBox( 'S� � poss�vel excluir um registro durante uma consulta.', 'Aten��o', MB_ICONEXCLAMATION);
end;

procedure TFcadunimed.btIncluirClick(Sender: TObject);
begin
     Application.CreateForm(TFcadunimed2, Fcadunimed2);
     Fcadunimed2.var_incluse := True;
     Fcadunimed2.ShowModal;
     FreeAndNil(Fcadunimed2);
     cdsconsulta.Refresh;
end;

procedure TFcadunimed.btLimparFiltroClick(Sender: TObject);
begin
     edPes.Text := '';
     cdsconsulta.Active;
     cdsconsulta.Filter   := ' UPPER(' + colsel + ') Like ' +UpperCase(QuotedStr('%' + Trim(edpes.Text) + '%'));
     cdsconsulta.Filtered := True;
end;

procedure TFcadunimed.btSairClick(Sender: TObject);
begin
     Close;
end;

procedure TFcadunimed.DbunimedDrawColumnCell(Sender: TObject;
  const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
     if not Odd((Dbunimed.DataSource.DataSet as TClientDataSet).RecNo) then
     begin
          if not (gdSelected in State) then
          begin
               Dbunimed.Canvas.Brush.Color := $00CBEAFE;
               Dbunimed.Canvas.FillRect(Rect);
               Dbunimed.DefaultDrawDataCell(Rect,Column.Field,State);
          end;
     end;

     Dbunimed.Canvas.Font.Color := clBlack;

     if gdSelected in State then
     begin
          Dbunimed.Canvas.Brush.Color:= $00F3EBD1;
          Dbunimed.Canvas.FillRect(rect);
     end;
     Dbunimed.DefaultDrawDataCell(Rect,Dbunimed.Columns[DataCol].Field, State);
end;

procedure TFcadunimed.DbunimedTitleClick(Column: TColumn);
var
     x : Integer;
begin
     for x := 0 to Dbunimed.Columns.Count -1 do
      Dbunimed.Columns[x].Title.Font.Color := clBlack;
     (Dbunimed.DataSource.DataSet as TClientDataSet).IndexFieldNames := Column.FieldName;
     Column.Title.Font.Color := clRed;
     colsel:= Column.FieldName;
end;

procedure TFcadunimed.edPesChange(Sender: TObject);
begin
     if Trim(edPes.Text) = '' then
     begin
          cdsconsulta.Active;
          cdsconsulta.Filter   := ' UPPER(' + colsel + ') Like ' +UpperCase(QuotedStr('%' + Trim(edpes.Text) + '%'));
          cdsconsulta.Filtered := True;

          Exit;
     end;

     if edpes.Text = '' then
     begin
          Application.MessageBox('Digite algo para pesquisar !','Aten��o',MB_ICONEXCLAMATION);
          Exit;
     end;

     cdsconsulta.Active;
     cdsconsulta.Filter   := ' UPPER(' + colsel + ') Like ' +UpperCase(QuotedStr('%' + Trim(edpes.Text) + '%'));
     cdsconsulta.Filtered := True;
end;

procedure TFcadunimed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     cdsconsulta.Close;
end;

procedure TFcadunimed.FormCreate(Sender: TObject);
begin
     cdsconsulta.Open;
     cdsconsulta.IndexFieldNames := 'CODUNIMED';
end;

procedure TFcadunimed.FormKeyPress(Sender: TObject; var Key: Char);
begin
     if (Key = #13) and not (ActiveControl is TMemo) then
     begin
          Perform(WM_NEXTDLGCTL,0,0);
     end;
end;

procedure TFcadunimed.FormShow(Sender: TObject);
begin
     Dbunimed.ontitleclick(Dbunimed.columns[2]);
     Dbunimed.SelectedIndex := 2;

     cdsconsulta.Active;
     cdsconsulta.Filter     := ' UPPER(' + colsel + ') Like ' +UpperCase(QuotedStr('%' + Trim(edpes.Text) + '%'));
     cdsconsulta.Filtered   := True;
end;

end.

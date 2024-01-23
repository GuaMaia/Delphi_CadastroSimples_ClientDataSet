unit Ucadprod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.FMTBcd, Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  Datasnap.Provider, Data.SqlExpr;

type
  Tfcadprod = class(TForm)
    Panel1: TPanel;
    btIncluir: TSpeedButton;
    btAlterar: TSpeedButton;
    btExcluir: TSpeedButton;
    btSair: TSpeedButton;
    Panel2: TPanel;
    Label1: TLabel;
    btLimparFiltro: TSpeedButton;
    edPes: TEdit;
    sdsconsulta: TSQLDataSet;
    dspconsulta: TDataSetProvider;
    cdsconsulta: TClientDataSet;
    dsconsulta: TDataSource;
    Dbprod: TDBGrid;
    cdsconsultaCODIGO: TIntegerField;
    cdsconsultaDESCRICAO: TStringField;
    cdsconsultaVALOR: TFMTBCDField;
    cdsconsultaCODUNMED: TIntegerField;
    cdsconsultaDESCUNIMED: TStringField;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure DbprodDrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DbprodTitleClick(Column: TColumn);
    procedure edPesChange(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btLimparFiltroClick(Sender: TObject);
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    colsel : String;
  public
    { Public declarations }
  end;

var
  fcadprod: Tfcadprod;

implementation

{$R *.dfm}

uses Umodulo, Ufcadprod2, UFrelprod;

procedure Tfcadprod.btAlterarClick(Sender: TObject);
begin
     if cdsconsulta.IsEmpty then EXIT;

     Application.CreateForm(Tfcadprod2, fcadprod2);
     fcadprod2.var_incluse := False;
     fcadprod2.ShowModal;
     FreeAndNil(fcadprod2);
     cdsconsulta.Refresh;
end;

procedure Tfcadprod.btExcluirClick(Sender: TObject);
begin
     if cdsconsulta.IsEmpty then EXIT;

     if cdsconsulta.State in [dsBrowse] then
     begin
          if Application.MessageBox('Deseja realmente excluir registro selecionado ?', 'Aten��o', mb_YesNo + MB_ICONQUESTION ) = IdYes then
          begin
               Application.CreateForm(Tfcadprod2, fcadprod2);
               fcadprod2.deletar;
               FreeAndNil(fcadprod2);
               cdsconsulta.Refresh;
               cdsconsulta.Refresh
          end;
     end
     else
          Application.MessageBox( 'S� � poss�vel excluir um registro durante uma consulta.', 'Aten��o', MB_ICONEXCLAMATION);
end;

procedure Tfcadprod.btIncluirClick(Sender: TObject);
begin
     Application.CreateForm(Tfcadprod2, fcadprod2);
     fcadprod2.var_incluse := True;
     fcadprod2.ShowModal;
     FreeAndNil(fcadprod2);
     cdsconsulta.Refresh;
end;

procedure Tfcadprod.btLimparFiltroClick(Sender: TObject);
begin
     edPes.Text := '';
     cdsconsulta.Active;
     cdsconsulta.Filter   := ' UPPER(' + colsel + ') Like ' +UpperCase(QuotedStr('%' + Trim(edpes.Text) + '%'));
     cdsconsulta.Filtered := True;
end;

procedure Tfcadprod.btSairClick(Sender: TObject);
begin
     Close;
end;

procedure Tfcadprod.DbprodDrawColumnCell(Sender: TObject;
  const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
     if not Odd((Dbprod.DataSource.DataSet as TClientDataSet).RecNo) then
     begin
          if not (gdSelected in State) then
          begin
               Dbprod.Canvas.Brush.Color := $00CBEAFE;
               Dbprod.Canvas.FillRect(Rect);
               Dbprod.DefaultDrawDataCell(Rect,Column.Field,State);
          end;
     end;

     Dbprod.Canvas.Font.Color := clBlack;

     if gdSelected in State then
     begin
          Dbprod.Canvas.Brush.Color:= $00F3EBD1;
          Dbprod.Canvas.FillRect(rect);
     end;
     Dbprod.DefaultDrawDataCell(Rect,Dbprod.Columns[DataCol].Field, State);
end;

procedure Tfcadprod.DbprodTitleClick(Column: TColumn);
var
     x : Integer;
begin
     for x := 0 to Dbprod.Columns.Count -1 do
      Dbprod.Columns[x].Title.Font.Color := clBlack;
     (Dbprod.DataSource.DataSet as TClientDataSet).IndexFieldNames := Column.FieldName;
     Column.Title.Font.Color := clRed;
     colsel:= Column.FieldName;
end;

procedure Tfcadprod.edPesChange(Sender: TObject);
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

procedure Tfcadprod.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     cdsconsulta.Close;
end;

procedure Tfcadprod.FormCreate(Sender: TObject);
begin
     cdsconsulta.Open;
     cdsconsulta.IndexFieldNames := 'CODIGO';
end;

procedure Tfcadprod.FormKeyPress(Sender: TObject; var Key: Char);
begin
     if (Key = #13) and not (ActiveControl is TMemo) then
     begin
          Perform(WM_NEXTDLGCTL,0,0);
     end;
end;

procedure Tfcadprod.FormShow(Sender: TObject);
begin
     Dbprod.ontitleclick(Dbprod.columns[2]);
     Dbprod.SelectedIndex := 2;

     cdsconsulta.Active;
     cdsconsulta.Filter     := ' UPPER(' + colsel + ') Like ' +UpperCase(QuotedStr('%' + Trim(edpes.Text) + '%'));
     cdsconsulta.Filtered   := True;
end;

procedure Tfcadprod.SpeedButton1Click(Sender: TObject);
begin
     if cdsconsulta.IsEmpty then EXIT;

     try
          Application.CreateForm(TFFrelprod,FFrelprod);
          FFrelprod.RelGeral.PreviewModal;
     finally
          FreeAndNil(FFrelprod);
     end;
end;

end.

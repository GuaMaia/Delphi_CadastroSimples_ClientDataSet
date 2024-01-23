unit UPesqcad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Data.DB, DBClient,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Data.FMTBcd, Data.SqlExpr,
  Datasnap.Provider;

type
  TFPesqcad = class(TForm)
    Panel1: TPanel;
    btSair: TSpeedButton;
    pnlCodBarras: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    lbpes: TLabel;
    edpes: TEdit;
    dbgpes: TDBGrid;
    edCodBarras: TEdit;
    sqlcon: TSQLQuery;
    SpeedButton1: TSpeedButton;
    dspesqcad: TDataSource;
    cdspesqcad: TClientDataSet;
    sdspesqcad: TSQLDataSet;
    dsppesqcad: TDataSetProvider;
    procedure edpesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbgpesDblClick(Sender: TObject);
    procedure dbgpesDrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgpesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgpesTitleClick(Column: TColumn);
    procedure edCodBarrasKeyPress(Sender: TObject; var Key: Char);
    procedure edpesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btSairClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bGridVazia : Boolean;
    edPesSelectAll : Boolean;
    edCodBarrasSetFocus : Boolean;
  end;

var
  FPesqcad: TFPesqcad;

implementation

{$R *.dfm}

uses Umodulo;

procedure TFPesqcad.btSairClick(Sender: TObject);
begin
     Close;
end;

procedure TFPesqcad.dbgpesDblClick(Sender: TObject);
begin
     fpesqcad.tag := 1;
     close;
end;

procedure TFPesqcad.dbgpesDrawColumnCell(Sender: TObject;
  const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
     if not (gdselected in State) then
          if not odd((dbgpes.datasource.dataset as tclientdataset).recno) then
               begin
                    dbgpes.Canvas.Brush.Color:= clGradientInactiveCaption;
                    dbgpes.Canvas.FillRect(rect);
                    dbgpes.DefaultDrawDataCell(Rect,Column.Field,State);
               end;
end;

procedure TFPesqcad.dbgpesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (ssCtrl in Shift) and (Key = VK_DELETE) then
     begin
          Beep;
          Key:= 0;
     end
     else if key = 13 then
     begin
          fpesqcad.tag := 1;
          Close();
     end;
end;

procedure TFPesqcad.dbgpesTitleClick(Column: TColumn);
begin
     cdspesqcad.IndexFieldNames := Column.FieldName;
     lbpes.Caption := Column.Title.Caption + ':';
     edpes.Text := '';
     edpes.SetFocus;
     edpes.SelectAll;
end;

procedure TFPesqcad.edCodBarrasKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
     begin
          Key := #0;
          edpes.SetFocus;
     end;
end;

procedure TFPesqcad.edpesChange(Sender: TObject);
var Code,I: Integer;
begin
     cdspesqcad.findnearest([edpes.text])
end;

procedure TFPesqcad.edpesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = 13 then
     begin
          fpesqcad.tag := 1;
          close;
     end;

     if key = 40 then
     begin
          ActiveControl := dbgpes;
     end;
end;

procedure TFPesqcad.FormActivate(Sender: TObject);
begin
     fpesqcad.tag := 0;

     if edPesSelectAll = False then
          edpes.SelStart := Length(edpes.Text);

     if edCodBarrasSetFocus = True then
          edCodBarras.SetFocus;
end;

procedure TFPesqcad.FormClose(Sender: TObject; var Action: TCloseAction);
var
     sFieldsAux : String;
     sDadosAux : array of Variant;
     x : Integer;
begin
     sqlcon.Close;

     if FPesqcad.Tag = 1 then
          bGridVazia := cdspesqcad.IsEmpty;
end;

procedure TFPesqcad.FormCreate(Sender: TObject);
begin
     edPesSelectAll      := True;
     edCodBarrasSetFocus := False;
end;

procedure TFPesqcad.FormShow(Sender: TObject);
begin
     ActiveControl := edpes;
end;

procedure TFPesqcad.SpeedButton1Click(Sender: TObject);
begin
     fpesqcad.tag := 1;
     close;
end;

end.



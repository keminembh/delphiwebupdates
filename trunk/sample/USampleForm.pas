unit USampleForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP;

type
  TSampleForm = class(TForm)
    lblVersao: TLabel;
    btnVersao: TButton;
    lblCurrentVersion: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnVersaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SampleForm: TSampleForm;

implementation

uses UVersionUpdate, UVersionInfo;

{$R *.dfm}

procedure TSampleForm.btnVersaoClick(Sender: TObject);
var lNewFile:  String;
begin
   try
     lNewFile := TVersionUpdate.Create.Download(Application.ExeName);
     ShowMessage('Restart application to run downloaded version');
   except on E: Exception do
     ShowMessage (E.Message);
   end;
end;

procedure TSampleForm.FormShow(Sender: TObject);
var lVersion : string;
    lLocalVersion : String;
begin
  lVersion := TVersionUpdate.Create.CheckUpdates(Application.ExeName);

  TVersionInfo.getInstance.SetAppName(Application.ExeName);
  lLocalVersion := TVersionInfo.getInstance().FileVersion;

  lblCurrentVersion.Caption := 'Current version: ' + lLocalVersion + '.';

  if(lVersion <> lLocalVersion) then
  begin
    lblVersao.Caption := 'New Version available: ' + lVersion + '. ';
    btnVersao.Enabled := true;
  end
  else
  begin
    lblVersao.Caption := 'No updates available';
    btnVersao.Enabled := false;
  end;
end;

end.

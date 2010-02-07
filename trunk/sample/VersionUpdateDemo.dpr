program VersionUpdateDemo;

uses
  Forms,
  USampleForm in 'USampleForm.pas' {SampleForm},
  UVersionInfo in '..\lib\UVersionInfo.pas',
  UVersionUpdate in '..\lib\UVersionUpdate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSampleForm, SampleForm);
  Application.Run;
end.

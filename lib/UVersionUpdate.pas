{: @abstract(Auto-Update unit)
    @author(Daniel Wildt <dwildt@gmail.com>)
    @created(February 07th of 2010)
    @lastmod(February 07th of 2010)
    @html(
      To use this class, create in your project a property called "updateURL".
      Use inside this property the URL where a "info.txt" file can be found
      and also the new executable (with the same filename of the current file).
      <br><br>
      The "info.txt" file contains only a version number. A text like "1.2.0.0".
      <br><br>
      In your code, you will add calls to Checkupdate and Download using your
      application name, like <i>TVersionUpdate.Create.CheckUpdates(Application.ExeName)</i>.
      This Class also uses a helper called TVersionInfo, where the app verion info
      can be extracted.
      <br><br><br>
      <b>Last modifications:</b>
      <ul>
        <li>07/02/2010 - file created </li>
      </ul>
    )
}
unit UVersionUpdate;

interface

uses
  Classes;

type

  {: Class responsible to update a executable. }
  TVersionUpdate = class(TPersistent)
  private
    function GetUpdateURL(const AAplicationName: String): String;
  protected
  public
    {: Based on updateURL, return value available inside info.txt. }
    function CheckUpdates(const AAplicationName: String): String;
    {:Download file available at updateURL location. }
    function Download(const AAplicationName: String): String;
  published
  end;

implementation

uses
  Windows, SysUtils, UVersionInfo, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,
  IdHTTP;

{ TVersionUpdate }

function TVersionUpdate.CheckUpdates(const AAplicationName: String): String;
var lIdHttp: TIdHTTP;
begin
  result := GetUpdateURL(AAplicationName);
  if (result <> '') then
  begin
    lIdHttp := TIdHTTP.Create(nil);
    result := lIdHttp.Get(result + '/info.txt');
  end;
end;

function TVersionUpdate.Download(const AAplicationName: String): String;
var lUrl : string;
    lIdHttp: TIdHTTP;
    lFileStream : TFileStream;
    lNewFileName : string;
begin
  lIdHttp := TIdHTTP.Create(nil);
  lUrl := GetUpdateURL(AAplicationName) + '/' + ExtractFileName(AAplicationName);
  lNewFileName := ChangeFileExt(AAplicationName,'.new');

  lFileStream := TFileStream.Create (lNewFileName, fmCreate);

  lIdHttp.Get(lUrl, lFileStream);

  lFileStream.Free;

  if(FileExists(lNewFileName)) then
  begin
    DeleteFile(ChangeFileExt(AAplicationName,'.old'));
    RenameFile(AAplicationName, ChangeFileExt(AAplicationName,'.old'));
    RenameFile(lNewFileName, ChangeFileExt(AAplicationName,'.exe'));

    result := lNewFileName;
  end
  else
    raise Exception.Create('Error downloading ' + ExtractFileName(AAplicationName));
end;

function TVersionUpdate.GetUpdateURL(const AAplicationName: string) : String;
begin
  TVersionInfo.getInstance.SetAppName(AAplicationName);
  result := TVersionInfo.getInstance.getPropertyValue('updateURL');
end;

end.

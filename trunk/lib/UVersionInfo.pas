{: @abstract(Extract application information)
    @author(Daniel Wildt <dwildt@gmail.com>)
    @created(December 16th 2003)
    @lastmod(February 07th of 2010)
    @html(
      Last modifications:
      <ul>
        <li>16/03/2005 - file created </li>
        <li>21/03/2005 - updated pasdoc documentation</li>
        <li>07/02/2010 - documentation updated to english</li>
      </ul>
    )
}
unit UVersionInfo;

interface

uses SysUtils, Classes, Windows;

const
  {: CompanyName}
  ivCOMPANY_NAME = 'CompanyName';
  {: FileDescription}
  ivFILE_DESCRIPTION = 'FileDescription';
  {: FileVersion}
  ivFILE_VERSION = 'FileVersion';
  {: InternalName}
  ivINTERNAL_NAME = 'InternalName';
  {: LegalCopyright}
  ivLEGAL_COPYRIGHT = 'LegalCopyright';
  {: LegalTradeMarks}
  ivLEGAL_TRADEMARKS = 'LegalTradeMarks';
  {: OriginalFilename}
  ivORIGINAL_FILENAME = 'OriginalFilename';
  {: ProductName }
  ivPRODUCT_NAME = 'ProductName';
  {: ProductVersion}
  ivPRODUCT_VERSION = 'ProductVersion';
  {: Comments}
  ivCOMMENTS = 'Comments';
  {: ReleaseDate - This is a customized field - to setup other fields, access
     Delphi Project -> Options, Version Info tab and add another field into the
     key/value grid. }
  ivRELEASE_DATE = 'ReleaseDate';

type

  {: Class responsible to read information about exe/dll/bpl. }
  TVersionInfo = class(TObject)
  private
    {: Store information read from a specific file}
    FInfoVersao: TStringList;
    {: internal constructor. }
    constructor CreateInstance;
    {: load version info}
    procedure LoadVersionInfo;

    // GetSet Methods.
    procedure SetComments(const Value: string);
    procedure SetCompanyName(const Value: string);
    procedure SetFileDescription(const Value: string);
    procedure SetFileVersion(const Value: string);
    procedure SetInternalName(const Value: string);
    procedure SetLegalCopyright(const Value: string);
    procedure SetLegalTradeMarks(const Value: string);
    procedure SetOriginalFilename(const Value: string);
    procedure SetProductName(const Value: string);
    procedure SetProductVersion(const Value: string);
    procedure SetReleaseDate(const Value: string);
    function GetComments: string;
    function GetCompanyName: string;
    function GetFileDescription: string;
    function GetFileVersion: string;
    function GetInternalName: string;
    function GetLegalCopyright: string;
    function GetLegalTradeMarks: string;
    function GetOriginalFilename: string;
    function GetProductName: string;
    function GetProductVersion: string;
    function GetReleaseDate: string;
  protected
    {: Release singleton memory. }
    class procedure releaseInstance();
  public
    property CompanyName: string read GetCompanyName write SetCompanyName;
    property FileDescription: string read GetFileDescription write
      SetFileDescription;
    property FileVersion: string read GetFileVersion write SetFileVersion;
    property InternalName: string read GetInternalName write SetInternalName;
    property LegalCopyright: string read GetLegalCopyright write
      SetLegalCopyright;
    property LegalTradeMarks: string read GetLegalTradeMarks write
      SetLegalTradeMarks;
    property OriginalFilename: string read GetOriginalFilename write
      SetOriginalFilename;
    property ProductName: string read GetProductName write SetProductName;
    property ProductVersion: string read GetProductVersion write
      SetProductVersion;
    property Comments: string read GetComments write SetComments;
    {: Custom Field. Release Date information. }
    property ReleaseDate: string read GetReleaseDate write SetReleaseDate;
    {: Other custom fields. You can get any property available inside the
       Version Info Tab Key/Value Grid. Just create a new property and use. }
    function getPropertyValue(propName: string): string;
    {: Return a StringList with all key/values}
    function getProperties(): TStringList;
    {: This class was built as a Singleton to facilitate usage. }
    class function getInstance(): TVersionInfo;
    {: Overriden constructor, to avoid its usage. It's a Singleton, use getInstance. }
    constructor Create;
    {: Initialize file to evaluate (exe/dll/bpl). }
    class procedure SetAppName(AAppName: string);
  end;

implementation

var
  {: global local instance variable. }
  instance: TVersionInfo;
  {: file being evaluated. }
  appName: string;

procedure TVersionInfo.LoadVersionInfo;
const
  {: default evaluated information.}
  Information: array[1..11] of string =
  (ivCOMPANY_NAME, ivFILE_DESCRIPTION, ivFILE_VERSION,
    ivINTERNAL_NAME, ivLEGAL_COPYRIGHT, ivLEGAL_TRADEMARKS,
    ivORIGINAL_FILENAME, ivPRODUCT_NAME, ivPRODUCT_VERSION,
    ivCOMMENTS, ivRELEASE_DATE);

var
  {: info version size. }
  infoSize: Cardinal;
  {: info version data. }
  buffer: PChar;
  {: for each read value. }
  readValue: PChar;
  readValueSize: Cardinal;
  counter: Integer;
begin
  infoSize := GetFileVersionInfoSize(PWideChar(appName), infoSize);
  if infoSize > 0 then
  begin
    buffer := AllocMem(infoSize);
    try
      GetFileVersionInfo(PChar(appName), 0, infoSize, buffer);
      for counter := 1 to High(Information) do
      begin
        // StringFileInfo\040904E4\ (English)
        // StringFileInfo\041604E4\ (Versão Português)
        if VerQueryValue(buffer, PChar('StringFileInfo\041604E4\' +
          Information[counter]), Pointer(readValue), readValueSize) then
        begin
          readValue := PChar(Trim(readValue));
          if Length(readValue) > 0 then
            FInfoVersao.Values[Information[counter]] := readValue;
        end;
      end;
    finally
      FreeMem(buffer, infoSize);
    end;
  end;
end;

constructor TVersionInfo.Create;
begin
  inherited Create;
  raise
    Exception.Create('Use TVersionInfo.getInstance to get a class instance!');
end;

constructor TVersionInfo.CreateInstance;
begin
  inherited Create;
  FInfoVersao := TStringList.Create;
  LoadVersionInfo;
end;

function TVersionInfo.GetComments: string;
begin
  result := FInfoVersao.Values[ivCOMMENTS]
end;

function TVersionInfo.GetCompanyName: string;
begin
  result := FInfoVersao.Values[ivCOMPANY_NAME];
end;

function TVersionInfo.GetFileDescription: string;
begin
  result := FInfoVersao.Values[ivFILE_DESCRIPTION];
end;

function TVersionInfo.GetFileVersion: string;
begin
  result := FInfoVersao.Values[ivFILE_VERSION];
end;

class function TVersionInfo.getInstance: TVersionInfo;
begin
  if (instance = nil) then
  begin
    instance := TVersionInfo.CreateInstance;
  end;
  result := instance;
end;

function TVersionInfo.GetInternalName: string;
begin
  result := FInfoVersao.Values[ivINTERNAL_NAME];
end;

function TVersionInfo.GetLegalCopyright: string;
begin
  result := FInfoVersao.Values[ivLEGAL_COPYRIGHT];
end;

function TVersionInfo.GetLegalTradeMarks: string;
begin
  result := FInfoVersao.Values[ivLEGAL_TRADEMARKS];
end;

function TVersionInfo.GetOriginalFilename: string;
begin
  result := FInfoVersao.Values[ivORIGINAL_FILENAME];
end;

function TVersionInfo.GetProductName: string;
begin
  result := FInfoVersao.Values[ivPRODUCT_NAME];
end;

function TVersionInfo.GetProductVersion: string;
begin
  result := FInfoVersao.Values[ivPRODUCT_VERSION];
end;

function TVersionInfo.getProperties: TStringList;
begin
  result := TStringList.Create;
  result.Text := FInfoVersao.Text;
end;

function TVersionInfo.getPropertyValue(propName: string): string;
var
  infoSize: Cardinal;
  buffer: PChar;
  readValue: PChar;
  readValueSize: Cardinal;
begin
  result := '';
  infoSize := GetFileVersionInfoSize(PWideChar(appName), infoSize);
  if infoSize > 0 then
  begin
    buffer := AllocMem(infoSize);
    try
      GetFileVersionInfo(PChar(appName), 0, infoSize, buffer);
      // StringFileInfo\040904E4\ (English)
      // StringFileInfo\041604E4\ (Versão Português)
      if VerQueryValue(buffer, PChar('StringFileInfo\041604E4\' +
        propName), Pointer(readValue), readValueSize) then
      begin
        readValue := PChar(Trim(readValue));
        if Length(readValue) > 0 then
          result:= readValue;
      end;
    finally
      FreeMem(buffer, infoSize);
    end;
  end;
end;

function TVersionInfo.GetReleaseDate: string;
begin
  result := FInfoVersao.Values[ivRELEASE_DATE];
end;

class procedure TVersionInfo.releaseInstance;
begin
  if (instance <> nil) then
    FreeAndNil(instance);
end;

class procedure TVersionInfo.SetAppName(AAppName: string);
begin
  releaseInstance;
  appName := AAppName;
end;

procedure TVersionInfo.SetComments(const Value: string);
begin
  FInfoVersao.Values[ivCOMMENTS] := Value;
end;

procedure TVersionInfo.SetCompanyName(const Value: string);
begin
  FInfoVersao.Values[ivCOMPANY_NAME] := Value;
end;

procedure TVersionInfo.SetFileDescription(const Value: string);
begin
  FInfoVersao.Values[ivFILE_DESCRIPTION] := Value;
end;

procedure TVersionInfo.SetFileVersion(const Value: string);
begin
  FInfoVersao.Values[ivFILE_VERSION] := Value;
end;

procedure TVersionInfo.SetInternalName(const Value: string);
begin
  FInfoVersao.Values[ivINTERNAL_NAME] := Value;
end;

procedure TVersionInfo.SetLegalCopyright(const Value: string);
begin
  FInfoVersao.Values[ivLEGAL_COPYRIGHT] := Value;
end;

procedure TVersionInfo.SetLegalTradeMarks(const Value: string);
begin
  FInfoVersao.Values[ivLEGAL_TRADEMARKS] := Value;
end;

procedure TVersionInfo.SetOriginalFilename(const Value: string);
begin
  FInfoVersao.Values[ivORIGINAL_FILENAME] := Value;
end;

procedure TVersionInfo.SetProductName(const Value: string);
begin
  FInfoVersao.Values[ivPRODUCT_NAME] := Value;
end;

procedure TVersionInfo.SetProductVersion(const Value: string);
begin
  FInfoVersao.Values[ivPRODUCT_VERSION] := Value;
end;

procedure TVersionInfo.SetReleaseDate(const Value: string);
begin
  FInfoVersao.Values[ivRELEASE_DATE] := Value;
end;

initialization
  appName := '';

end.


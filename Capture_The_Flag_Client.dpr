program Capture_The_Flag_Client;

uses
  Forms,
  Unit3 in 'Unit3.pas' {MainForm},
  Unit2 in 'Unit2.pas' {AboutBox},
  Unit4 in 'Unit4.pas' {Server},
  Unit5 in 'Unit5.pas' {Server1},
  Unit7 in 'Unit7.pas' {instructions2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Capture The Flag';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TServer, Server);
  Application.CreateForm(TServer1, Server1);
  Application.CreateForm(Tinstructions2, instructions2);
  Application.Run;
end.









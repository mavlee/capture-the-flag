program Capture_The_Flag_Server;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  Unit2 in 'Unit2.pas' {AboutBox},
  Unit6 in 'Unit6.pas' {Instructions};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Capture The Flag';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TInstructions, Instructions);
  Application.Run;
end.

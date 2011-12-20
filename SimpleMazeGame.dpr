program SimpleMazeGame;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  Unit2 in 'Unit2.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Munchu''s Adventure';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.

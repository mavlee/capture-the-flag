program AI_Test;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Munchu''s Adventure';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

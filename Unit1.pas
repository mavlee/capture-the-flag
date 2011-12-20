unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ScktComp, ComCtrls, StdCtrls, Math;

const
   PATH = 0;
   BRICK = 1;
   BLUEFLAG = 3;
   REDFLAG = 4;
type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ServerSocket1: TServerSocket;
    Settings1: TMenuItem;
    NumberofLives1: TMenuItem;
    MapChoice1: TMenuItem;
    N12: TMenuItem;
    N22: TMenuItem;
    N32: TMenuItem;
    N42: TMenuItem;
    N52: TMenuItem;
    N61: TMenuItem;
    Timer1: TTimer;
    Label1: TLabel;
    redAITimer: TTimer;
    blueAItimer: TTimer;
    StrategicBattlefield1: TMenuItem;
    Vortex1: TMenuItem;
    Deathmatch1: TMenuItem;
    OpenPlains1: TMenuItem;
    Confusion1: TMenuItem;
    Labyrinth1: TMenuItem;
    RedLifeCaption: TLabel;
    BlueLifeCaption: TLabel;
    RedPlayerName: TEdit;
    ChatMessage: TEdit;
    Send: TButton;
    ChatMemo: TMemo;
    PositionTimer: TTimer;
    EnemyPlayerLabel: TLabel;
    Bearing: TLabel;
    eventLabel: TLabel;
    EventTimer: TTimer;
    About2: TMenuItem;
    N1: TMenuItem;
    MediumMaps1: TMenuItem;
    LargeMaps1: TMenuItem;
    Bevel2: TBevel;
    Disaster1: TMenuItem;
    Torrential1: TMenuItem;
    Stadium1: TMenuItem;
    Spiral1: TMenuItem;
    Monoworld1: TMenuItem;
    Haxed1: TMenuItem;
    mapNameLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure New1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure redAITimerTimer(Sender: TObject);
    procedure blueAItimerTimer(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure StrategicBattlefield1Click(Sender: TObject);
    procedure Vortex1Click(Sender: TObject);
    procedure Deathmatch1Click(Sender: TObject);
    procedure OpenPlains1Click(Sender: TObject);
    procedure Confusion1Click(Sender: TObject);
    procedure Labyrinth1Click(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure PositionTimerTimer(Sender: TObject);
    procedure EventTimerTimer(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure Disaster1Click(Sender: TObject);
    procedure Torrential1Click(Sender: TObject);
    procedure Stadium1Click(Sender: TObject);
    procedure Spiral1Click(Sender: TObject);
    procedure Monoworld1Click(Sender: TObject);
    procedure Haxed1Click(Sender: TObject);
    procedure ChatMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure NewGame(life:integer);
    procedure ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn : Integer);
    procedure ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column : Integer);
    procedure LoadUpMaze(fileName : String);
  public
    maze : array[1..100, 1..100] of Integer;
    playerRow : Integer;
    player2Row : Integer;
    playerColumn : Integer;
    player2Column : Integer;
    defaultPlayerRow : Integer;
    defaultPlayer2Row : Integer;
    defaultPlayerColumn : Integer;
    defaultPlayer2Column : Integer;
    blueAIBitmap :tBitmap;
    redAIBitmap : tBitmap;
    visionUpgradeBitmap : tBitmap;
    mazeBitmaps : array [0..4] of TBitmap;
    playerBitmap : TBitmap;
    player2Bitmap : Tbitmap;
    cellWidth, cellHeight : Integer;
    redFlagCapture, blueFlagCapture : boolean;
    life, redLife, blueLife : integer;
    ChatEnabled : boolean;
    redAIRow: array[1..6] of Integer;
    redAIColumn : array[1..6] of Integer;
    blueAIRow: array[1..6] of Integer;
    blueAIColumn : array[1..6] of Integer;
    defaultRedAIRow: array[1..6] of integer;
    defaultRedAIColumn : array[1..6] of Integer;
    defaultBlueAIRow: array[1..6] of integer;
    defaultBlueAIColumn : array[1..6] of Integer;
    enemyPlayerName : string;
    visionAmount : integer;
    noOfRows, noOfColumns : integer;
    glassesRow, glassesColumn : integer;
    stealthBitmap : tBitmap;
    stealthRow, stealthColumn : integer;
    redStealthed, blueStealthed : boolean;
    randomAIMovingCounter : integer;
    teleporterBitmap : tBitmap;
    teleporter1Row, teleporter2Row : integer;
    teleporter1Column, teleporter2Column : integer;
    mapName : string;
    glasses2Row, glasses2Column : integer;
  end;

var
  MainForm: TMainForm;

implementation

uses Unit2, Unit6;

{$R *.dfm}


procedure TMainForm.NewGame(life:integer);
begin
  redStealthed := false;
  redstealthed := false;
  Bevel2.Width := 360;
  Bevel2.Height := 360;
  visionAmount := 4;
  blueLife := life;
  redLife := life;
  chatEnabled := false;
  Timer1.Enabled := true;
  Label1.Visible := true;
  Label1.Caption := '5';
  redAITimer.Enabled := false;
  blueAiTimer.Enabled := false;
  RedLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(redLife);
  BlueLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(blueLife);
  if ServerSocket1.Socket.ActiveConnections = 1 then
    begin
      ServerSocket1.Socket.Connections[0].SendText('t');
      if life = 1 then
        ServerSocket1.Socket.Connections[0].SendText('Q')
      else if life = 2 then
        ServerSocket1.Socket.Connections[0].SendText('W')
      else if life = 3 then
        ServerSocket1.Socket.Connections[0].SendText('E')
      else if life = 4 then
        ServerSocket1.Socket.Connections[0].SendText('R')
      else if life = 5 then
        ServerSocket1.Socket.Connections[0].SendText('T')
      else
        ServerSocket1.Socket.Connections[0].SendText('Y');
    end;
  Invalidate;  
end;

procedure TMainForm.ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn : Integer);
begin
  redStealthed := false;
  playerBitmap.LoadFromFile('reddude.bmp');
  playerRow := defaultPlayerRow;
  playerColumn := defaultPlayerColumn;
  mazeBitmaps[BLUEFLAG].LoadFromFile('blueflag.bmp');
  blueFlagCapture := false;
  Invalidate;
end;

procedure TMainForm.ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column : Integer);
begin
  blueStealthed := false;
  player2Bitmap.LoadFromFile('bluedude.bmp');
  player2Row := defaultPlayer2Row;
  player2Column := defaultPlayer2Row;
  mazeBitmaps[REDFLAG].LoadFromFile('redflag.bmp');
  redFlagCapture := false;
  Invalidate;
end;  

procedure TMainForm.LoadUpMaze(fileName : String);
var
   mazeFile : TextFile;
   row, column : Integer;
   rowLine : String;
   counter : integer;
begin
   // Load in the file data into the maze
   AssignFile(mazeFile, 'Mazes\' + filename);
   Reset(mazeFile);
   Readln(mazefile, noOfRows);
   noOfColumns := noOfRows;
   Readln(mazeFile, teleporter1Row);
   Readln(mazeFile, teleporter1Column);
   Readln(mazeFile, teleporter2Row);
   Readln(mazeFile, teleporter2Column);
   Readln(mazeFile, playerRow);
   Readln(mazeFile, playerColumn);
   Readln(mazeFile, player2Row);
   Readln(mazeFile, player2Column);
   defaultPlayerRow := playerRow;
   defaultPlayerColumn := playerColumn;
   defaultPlayer2Row := player2Row;
   defaultPlayer2Column := player2Column;
   for counter := 1 to 6 do
     begin
       Readln(mazeFile, redAIRow[counter]);
       defaultRedAIRow[counter] := redAIRow[counter];
     end;
   for counter := 1 to 6 do
     begin
       Readln(mazeFile, redAIColumn[counter]);
       defaultRedAIColumn[counter] := redAIColumn[counter];
     end;
   for counter := 1 to 6 do
     begin
       Readln(mazefile, blueAIRow[counter]);
       defaultBlueAIRow[counter] := blueAIRow[counter];
     end;
   for counter := 1 to 6 do
     begin
       Readln(mazeFile, blueAIColumn[counter]);
       defaultBlueAIColumn[counter] := blueAIColumn[counter];
     end;

   for row := 1 to noOfRows do
   begin
      // Read a line of the maze file, then convert each char
      // in the line into a number
      Readln(mazeFile, rowLine);
      for column := 1 to noOfColumns do
      begin
         maze[row,column] := StrToInt(rowLine[column]);
      end;
   end;
   CloseFile(mazeFile);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
   ServerSocket1.Port := 2310;
   ServerSocket1.Active := true;
   enemyPlayerName := 'Blue Player';
   visionAmount := 4;
   randomAIMovingCounter := 0;
   mapName := 'Strategic Battlefield';
   Randomize;

   DoubleBuffered := true;

   life := 3;
   redLife := 3;
   blueLife := 3;

   // Create and load up the image files
   playerBitmap := TBitmap.Create;
   playerBitmap.LoadFromFile('reddude.bmp');
   playerBitmap.Transparent := true;
   player2Bitmap := TBitmap.Create;
   player2Bitmap.LoadFromFile('bluedude.bmp');
   player2Bitmap.Transparent := true;
   RedAIBitmap := TBitmap.Create;
   RedAiBitmap.LoadFromFile('rednpc.bmp');
   RedAiBitmap.Transparent := true;
   blueAIBitmap := TBitmap.Create;
   blueAiBitmap.LoadFromFile('bluenpc.bmp');
   blueAiBitmap.Transparent := true;
   mazeBitmaps[PATH] := TBitmap.Create;
   mazeBitmaps[PATH].LoadFromFile('path.bmp');
   mazeBitmaps[BRICK] := TBitmap.Create;
   mazeBitmaps[BRICK].LoadFromFile('brick.bmp');
   mazeBitmaps[REDFLAG] := TBitmap.Create;
   mazeBitmaps[REDFLAG].LoadFromFile('redflag.bmp');
   mazeBitmaps[BLUEFLAG] := TBitmap.Create;
   mazeBitmaps[BLUEFLAG].LoadFromFile('blueflag.bmp');
   visionUpgradeBitmap := tBitmap.Create;
   visionUpgradeBitmap.LoadFromFile('glasses.bmp');
   visionUpgradeBitmap.Transparent := true;
   stealthBitmap := tBitmap.Create;
   stealthBitmap.LoadFromFile('disguise.bmp');
   stealthBitmap.Transparent := true;
   teleporterBitmap := tBitmap.Create;
   teleporterBitmap.LoadFromFile('teleporter.bmp');
   teleporterBitmap.Transparent := true;


   // Set the width of each cell in the maze to the brick's bitmap size
   cellWidth := mazeBitmaps[BRICK].Width;
   cellHeight := mazeBitmaps[BRICK].Height;

   // Load up the maze
   LoadUpMaze('maze01.txt');

   NewGame(life);

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   // Free up the bitmap images
   playerBitmap.Free;
   player2Bitmap.Free;
   mazeBitmaps[PATH].Free;
   mazeBitmaps[BRICK].Free;
   redAIbitmap.Free;
end;

// Repaints the form
// Needed since we are drawing the bitmaps on the form
// instead of placing TImage objects on the form
procedure TMainForm.FormPaint(Sender: TObject);
var
   row, column: Integer;
   xPos, yPos : Integer;
   index : Integer;
   startRow, startColumn : integer;
   endRow, EndColumn : integer;
begin
   startRow := Max(playerRow - visionAmount, 1);
   startColumn := Max(playerColumn - visionAmount, 1);
   endRow := startRow + visionAmount * 2;
   if endRow > noOfRows then
     begin
       endRow := noOfRows;
       startRow := noOfRows - visionAmount * 2;
     end;
   endColumn := startColumn + visionAmount * 2;
   if endColumn > noOfColumns then
     begin
       endColumn := noOfColumns;
       startColumn := noOfColumns - visionAmount * 2;
     end;
   // Draw the current maze using the appropriate images
   for row := startRow to endRow do
   begin
      for column := startColumn to endColumn do
      begin
         xPos := (column-startColumn)* cellWidth;
         yPos := (row-startRow)* cellHeight;
         Canvas.Draw(xPos, yPos, mazeBitmaps[maze[row,column]]);
      end;
   end;
   // Draw the player
   xPos := (playerColumn-startColumn)* cellWidth;
   yPos := (playerRow-startRow)* cellHeight;
   Canvas.Draw(xPos, yPos,playerBitmap);

   xPos := (player2Column-startColumn)* cellWidth;
   yPos := (player2Row-startRow)* cellHeight;
   if (player2Column >= startColumn) and (player2Column <= endColumn) and (player2Row >= startRow) and (player2Row <= endRow) then
     Canvas.Draw(xPos, yPos, player2Bitmap);

   xPos := (glassesColumn-startColumn)* cellWidth;
   yPos := (glassesRow-startRow)* cellHeight;
   if (glassesColumn >= startColumn) and (glassesColumn <= endColumn) and (glassesRow >= startRow) and (glassesRow <= endRow) then
     Canvas.Draw(xPos, yPos, visionUpgradeBitmap);

   xPos := (glasses2Column-startColumn)* cellWidth;
   yPos := (glasses2Row-startRow)* cellHeight;
   if (glasses2Column >= startColumn) and (glasses2Column <= endColumn) and (glasses2Row >= startRow) and (glasses2Row <= endRow) then
     Canvas.Draw(xPos, yPos, visionUpgradeBitmap);

   xPos := (stealthColumn - startColumn) * cellWidth;
   yPos := (stealthRow - startRow) * cellHeight;
   if (stealthColumn >= startColumn) and (stealthColumn <= endColumn) and (stealthRow >= startRow) and (stealthRow <= endRow) then
     Canvas.Draw(xPos, yPos, stealthBitmap);

   xPos := (teleporter1Column - startColumn) * cellWidth;
   yPos := (teleporter1Row - startRow) * cellHeight;
   if (teleporter1Column >= startColumn) and (teleporter1Column <= endColumn) and (teleporter1Row >= startRow) and (teleporter1Row <= endRow) then
     Canvas.Draw(xPos, yPos, teleporterBitmap);

   xPos := (teleporter2Column - startColumn) * cellWidth;
   yPos := (teleporter2Row - startRow) * cellHeight;
   if (teleporter2Column >= startColumn) and (teleporter2Column <= endColumn) and (teleporter2Row >= startRow) and (teleporter2Row <= endRow) then
     Canvas.Draw(xPos, yPos, teleporterBitmap);

   for index := 1 to 6 do
     begin
       xPos := (RedAIColumn[index]-startColumn)* cellWidth;
       yPos := (redAIRow[index]-startRow)* cellHeight;
       if (RedAIColumn[index] >= startColumn) and (RedAIColumn[index] <= endColumn) and (RedAIRow[index] >= startRow) and (RedAIRow[index] <= endRow) then
         Canvas.Draw(xPos, yPos, redAIBitmap);
     end;
   for index := 1 to 6 do
     begin
       xPos := (blueAIColumn[index]-startColumn)* cellWidth;
       yPos := (blueAIRow[index]-startRow)* cellHeight;
       if (BlueAIColumn[index] >= startColumn) and (BlueAIColumn[index] <= endColumn) and (BlueAIRow[index] >= startRow) and (BlueAIRow[index] <= endRow) then
         Canvas.Draw(xPos, yPos, blueAIBitmap);
     end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   oldRow : Integer;
   oldColumn : Integer;
   aiIndex : integer;
begin
   oldRow := playerRow;
   oldColumn := playerColumn;
   // Respond to each arrow key
   case Key of
      VK_LEFT :
         dec(playerColumn);
      VK_RIGHT :
         inc(playerColumn);
      VK_UP :
         dec(playerRow);
      VK_DOWN :
         inc(playerRow);
      Ord('A') :
         Dec(playerColumn);
      Ord('D') :
         inc(playerColumn);
      Ord('W') :
         dec(playerRow);
      Ord('S') :
         inc(playerRow);
      VK_SPACE :
        begin
          if ChatEnabled = false then
            begin
              RedPlayerName.Enabled := true;
              ChatMessage.Enabled := true;
              Send.Enabled := true;
              ChatMemo.Enabled := true;
              ChatEnabled := true;
            end
          else if ChatEnabled = true then
            begin
              RedPlayerName.Enabled := false;
              ChatMessage.Enabled := false;
              Send.Enabled := false;
              ChatMemo.Enabled := false;
              ChatEnabled := false;
            end;
       end;
   end;


   if maze[playerRow, playerColumn] = 1 then
     begin
       playerRow := oldRow;
       playerColumn := oldColumn;
     end
   else
     begin
       if redStealthed = true then
         begin
         end
       else if (KEY = VK_LEFT) or (KEY = Ord('A')) then
         begin
           if blueFlagCapture = true then
             playerBitmap.LoadFromFile('reddudewithflagleft.bmp')
           else
             playerBitmap.LoadFromFile('reddudeleft.bmp');
         end
       else if (KEY = VK_RIGHT) or (KEY = Ord('D')) then
         begin
           if blueFlagCapture = true then
             playerBitmap.LoadFromFile('reddudewithflagright.bmp')
           else
             playerBitmap.LoadFromFile('redduderight.bmp');
         end;
       if ServerSocket1.Socket.ActiveConnections = 1 then
         begin
           if (playerRow < 10) and (playerColumn < 10) then
             ServerSocket1.Socket.Connections[0].SendText('p0' + IntToStr(playerRow) + '0' + IntToStr(playerColumn))
           else if playerRow < 10 then
             ServerSocket1.Socket.Connections[0].SendText('p0' + IntToStr(playerRow) + IntToStr(playerColumn))
           else if playerColumn < 10 then
             ServerSocket1.Socket.Connections[0].SendText('p' + IntToStr(playerRow) + '0' + IntToStr(playerColumn))
           else
             ServerSocket1.Socket.Connections[0].SendText('p' + IntToStr(playerRow) + IntToStr(playerColumn));
         end;
     end;

   // If the player moved, redraw the player in the new position
   if (playerRow <> oldRow) or (playerColumn <> oldColumn) then
   begin
       Invalidate;
   end;

   if maze[playerRow, playerColumn] = BLUEFLAG then
     begin
       redStealthed := false;
       playerBitmap.LoadFromFile('reddudewithflag.bmp');
       mazeBitmaps[BLUEFLAG].LoadFromFile('flagpod.bmp');
       eventLabel.Caption := 'You got ' + enemyPlayerName + '''s flag!';
       eventTimer.enabled := true;
       eventLabel.Font.Color:=clRed;
       blueFlagCapture := true;
       redStealthed := false;
       Invalidate;
     end;

   if (redFlagCapture = true) and (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
     begin
       ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
       ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
       eventLabel.Caption:= 'Your both got captured!';
       eventLabel.Font.Color:=clBlack;
       eventTimer.enabled:=true;
     end
   else if (redFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
     begin
       ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
       eventLabel.Caption := enemyPlayerName +  ' got captured by you!';
       eventLabel.Font.Color := clRed;
       eventTimer.enabled := true;
     end
   else if (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
     begin
       ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
       eventLabel.caption := 'You got captured by ' + enemyPlayerName + '!';
       eventLabel.Font.Color := clBlue;
       eventTimer.Enabled := true;
     end
   else if (playerRow = glassesRow) and (playerColumn = glassesColumn) then
     begin
       visionAmount := 5;
       glassesRow := 0;
       glassesColumn := 0;
       Bevel2.Width := 440;
       Bevel2.Height := 440;
       eventLabel.caption := 'You got improved vision!';
       eventLabel.Font.Color := clRed;
       eventTimer.Enabled := true;
     end
   else if (playerRow = glasses2Row) and (playerColumn = glasses2Column) then
     begin
       visionAmount := 5;
       glasses2Row := 0;
       glasses2Column := 0;
       Bevel2.Width := 440;
       Bevel2.Height := 440;
       eventLabel.caption := 'You got improved vision!';
       eventLabel.Font.Color := clRed;
       eventTimer.Enabled := true;
     end
   else if (playerRow = stealthRow) and (playerColumn = stealthColumn) then
     begin
       stealthRow := 0;
       stealthRow := 0;
       eventLabel.caption := 'You become stealthier...';
       eventLabel.Font.Color := clRed;
       eventTimer.Enabled := true;
       redStealthed := true;
       playerBitmap.LoadFromFile('bluenpc.bmp');
     end
   else if (playerRow = teleporter1Row) and (playerColumn = teleporter1Column) then
     begin
       playerRow := teleporter2Row;
       playerColumn := teleporter2Column;
     end
   else if (playerRow = teleporter2Row) and (playerColumn = teleporter2Column) then
     begin
       playerRow := teleporter1Row;
       playerColumn := teleporter1Column;
     end;

   if (maze[playerRow, playerColumn] = 4) and (blueFlagCapture = true) then
    begin
      Dec(blueLife);
      ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
      BlueLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(blueLife);
      eventLabel.caption := 'You captured ' + enemyPlayerName + '''s flag!';
      eventLabel.Font.Color := clRed;
      eventTimer.Enabled := true;
      if blueLife = 0 then
        begin
          ShowMessage('You win');
          NewGame(life);
        end;
    end;

    for aiIndex := 1 to 6 do
      begin
       if (blueAIColumn[aiIndex] = playerColumn) and (blueAIRow[aiIndex] = playerRow) then
         begin
           ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
           blueAIColumn[aiIndex] := defaultBlueAIColumn[aiIndex];
           blueAIRow[aiIndex] := defaultBlueAIRow[aiIndex];
           if ServerSocket1.Socket.ActiveConnections = 1 then
             ServerSocket1.Socket.Connections[0].SendText('b' + IntToStr(aiIndex));
           eventLabel.caption := 'You got captured by ' + enemyPlayerName + '''s hired ninjas!';
           eventLabel.Font.Color := clBlue;
           eventTimer.Enabled := true;
         end;
       end;

   Invalidate;
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
  NewGame(life);
  Invalidate;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  instructions.ShowModal;
end;


procedure TMainForm.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  direction : string;
  index : integer;
  index2 : integer;
  aiIndex : integer;
begin
  index2 := 0;
  with ServerSocket1.Socket.Connections[0] do
    direction := ReceiveText;

  for index := 1 to Length(direction) do
    begin
      if direction[index] = 'ç' then
        begin
          for index2 := index + 1 to Length(direction) - 1 do
            begin
              if direction[index2] = 'ç' then
                begin
                  ChatMemo.Lines.Add(Copy(direction, index + 1, index2 - 2) + ' says:');
                  enemyPlayerName := Copy(direction, index + 1, index2 - 2);
                  ChatMemo.Lines.Add(Copy(direction, index2 + 1, Length(direction) - index2 - 1));
                  ChatMemo.Lines.Add('');
                end;
            end;
         end

      else if (direction[index] = 'p') and (index2 = 0) then
        begin
          player2Row := StrToInt(Copy(direction, index + 1, 2));
          player2Column := StrToInt(Copy(direction, index + 3, 2));

          if maze[player2Row, player2Column] = REDFLAG then
            begin
              blueStealthed := false;
              player2Bitmap.LoadFromFile('bluedudewithflag.bmp');
              mazeBitmaps[REDFLAG].LoadFromFile('flagpod.bmp');
              redFlagCapture := true;
              eventLabel.caption := enemyPlayerName +  ' has taken your flag!';
              eventLabel.Font.Color := clBlue;
              eventTimer.Enabled := true;
            end;

          if (redFlagCapture = true) and (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
            begin
              ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
              ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
              eventLabel.Caption:= 'You and your opponent got captured!';
              eventLabel.Font.Color:=clBlack;
              eventTimer.enabled:=true;
            end
          else if (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
            begin
              ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
              eventLabel.Caption:= 'You got captured by ' + enemyPlayerName + '!';
              eventLabel.Font.Color:=clBlue;
              eventTimer.enabled:=true;
            end
          else if (redFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
            begin
              ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
              eventLabel.Caption:= enemyPlayerName + ' got captured by you!';
              eventLabel.Font.Color := clRed;
              eventTimer.enabled := true;
            end
          else if (player2Row = glassesRow) and (player2Column = glassesColumn) then
            begin
              glassesRow := 0;
              glassesColumn := 0;
              Invalidate;
            end
          else if (player2Row = glasses2Row) and (player2Column = glasses2Column) then
            begin
              glasses2Row := 0;
              glasses2Column := 0;
              Invalidate;
            end
          else if (player2Row = stealthRow) and (player2Column = stealthColumn) then
            begin
              stealthRow := 0;
              stealthColumn := 0;
              player2Bitmap.LoadFromFile('rednpc.bmp');
              blueStealthed := true;
              Invalidate;
            end
          else if (player2Row = teleporter1Row) and (player2Column = teleporter1Column) then
            begin
              player2Row := teleporter2Row;
              player2Column := teleporter2Column;
            end
          else if (player2Row = teleporter2Row) and (player2Column = teleporter2Column) then
            begin
              player2Row := teleporter1Row;
              player2Column := teleporter1Column;
            end;

          if (maze[player2Row, player2Column] = 3) and (redFlagCapture = true) then
            begin
              Dec(redLife);
              ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
              RedLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(redLife);
              eventLabel.caption := enemyPlayerName + ' has captured your flag!';
              eventLabel.Font.Color := clBlue;
              eventTimer.Enabled := true;
              if redLife = 0 then
                begin
                  ShowMessage('You lose');
                  NewGame(life);
                end;
            end;

          for aiIndex := 1 to 6 do
            begin
              if (redAIColumn[aiIndex] = player2Column) and (redAIRow[aiIndex] = player2Row) then
                begin
                  ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
                  redAIColumn[aiIndex] := defaultRedAIColumn[aiIndex];
                  redAIRow[aiIndex] := defaultRedAIRow[aiIndex];
                  if ServerSocket1.Socket.ActiveConnections = 1 then
                    ServerSocket1.Socket.Connections[0].SendText('r' + IntToStr(aiIndex));
                  eventLabel.caption := enemyPlayerName + ' got captured by your hired ninjas!';
                  eventLabel.Font.Color := clRed;
                  eventTimer.Enabled := true;
                end;
            end;
          Invalidate;
        end;
  end;
end;

procedure TMainForm.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
    ShowMessage('A player just connected!' + #10 + 'Press ok to start new game!');
    NewGame(life);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  aiIndex : integer;
begin
  Label1.Caption := IntToStr(StrToInt(label1.Caption) - 1);
  if Label1.Caption = '0' then
    begin
      Timer1.Enabled := false;
      Label1.Visible := false;
      Label1.Caption := '5';
      ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
      ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
      glassesRow := Random(noOfRows) + 1;
      glassesColumn := Random(noOfColumns) + 1;
      while (maze[glassesRow, glassesColumn] = 1) or ((glassesRow = playerRow) and (glassesColumn = playerColumn)) or ((glassesRow = player2Row) and (glassesColumn = player2Column)) do
        begin
          glassesRow := Random(noOfRows) + 1;
          glassesColumn := Random(noOfColumns) + 1;
        end;
      if ServerSocket1.Socket.ActiveConnections = 1 then
        begin
          if (glassesRow < 10) and (glassesColumn < 10) then
            ServerSocket1.Socket.Connections[0].SendText('g10' + IntToStr(glassesRow) + '0' + IntToStr(glassesColumn))
          else if glassesRow < 10 then
            ServerSocket1.Socket.Connections[0].SendText('g10' + IntToStr(glassesRow) + IntToStr(glassesColumn))
          else if glassesColumn < 10 then
            ServerSocket1.Socket.Connections[0].SendText('g1' + IntToStr(glassesRow) + '0' + IntToStr(glassesColumn))
          else
            ServerSocket1.Socket.Connections[0].SendText('g1' + IntToStr(glassesRow) + IntToStr(glassesColumn));
        end;
      glasses2Row := Random(noOfRows) + 1;
      glasses2Column := Random(noOfColumns) + 1;
      while (maze[glasses2Row, glasses2Column] = 1) or ((glassesRow = playerRow) and (glassesColumn = playerColumn)) or ((glassesRow = player2Row) and (glassesColumn = player2Column)) or ((glassesRow = glasses2Row) and (glassesColumn = glasses2Column))  do
        begin
          glasses2Row := Random(noOfRows) + 1;
          glasses2Column := Random(noOfColumns) + 1;
        end;
      if ServerSocket1.Socket.ActiveConnections = 1 then
        begin
          if (glasses2Row < 10) and (glasses2Column < 10) then
            ServerSocket1.Socket.Connections[0].SendText('g20' + IntToStr(glasses2Row) + '0' + IntToStr(glasses2Column))
          else if glasses2Row < 10 then
            ServerSocket1.Socket.Connections[0].SendText('g20' + IntToStr(glasses2Row) + IntToStr(glasses2Column))
          else if glasses2Column < 10 then
            ServerSocket1.Socket.Connections[0].SendText('g2' + IntToStr(glasses2Row) + '0' + IntToStr(glasses2Column))
          else
            ServerSocket1.Socket.Connections[0].SendText('g2' + IntToStr(glasses2Row) + IntToStr(glasses2Column));
        end;
      stealthRow := Random(noOfRows) + 1;
      stealthColumn := Random(noOfColumns) + 1;
      while (maze[stealthRow, stealthColumn] = 1) or ((stealthRow = playerRow) and (stealthColumn = playerColumn)) or ((stealthRow = player2Row) and (stealthColumn = player2Column)) or ((stealthRow = glassesRow) and (stealthColumn = glassesColumn)) or ((stealthRow = glasses2Row) and (stealthColumn = glasses2Column)) do
        begin
          stealthRow := Random(noOfRows) + 1;
          stealthColumn := Random(noOfColumns) + 1;
        end;
      if ServerSocket1.Socket.ActiveConnections = 1 then
        begin
          if (stealthRow < 10) and (stealthColumn < 10) then
            ServerSocket1.Socket.Connections[0].SendText('s0' + IntToStr(stealthRow) + '0' + IntToStr(stealthColumn))
          else if stealthRow < 10 then
            ServerSocket1.Socket.Connections[0].SendText('s0' + IntToStr(stealthRow) + IntToStr(stealthColumn))
          else if stealthColumn < 10 then
            ServerSocket1.Socket.Connections[0].SendText('s' + IntToStr(stealthRow) + '0' + IntToStr(stealthColumn))
          else
            ServerSocket1.Socket.Connections[0].SendText('s' + IntToStr(stealthRow) + IntToStr(stealthColumn));
        end;
      for aiIndex := 1 to 6 do
        begin
          redAIColumn[aiIndex] := defaultRedAIColumn[aiIndex];
          redAIRow[aiIndex] := defaultRedAIRow[aiIndex];
          blueAIColumn[aiIndex] := defaultBlueAIColumn[aiIndex];
          blueAIRow[aiIndex] := defaultBlueAIRow[aiIndex];
        end;
      redAITimer.Enabled := true;
      blueAITimer.Enabled := true;
      Invalidate;
    end;
end;

procedure TMainForm.redAITimerTimer(Sender: TObject);
var
 aiindex:integer;
begin
   if blueStealthed = true then
     begin
       Inc(randomAIMovingCounter);
       if randomAIMovingCounter = 5 then
         randomAIMovingCounter := 1;
       for aiIndex := 1 to 6 do
         begin
           if (randomAIMovingCounter = 1) and (maze[redAIrow[aiIndex]-1,redAIColumn[aiIndex]]<>1) then
             redAIrow[aiIndex] := redAIrow[aiIndex] - 1
           else if (randomAIMovingCounter = 2) and (maze[redAIrow[aiIndex]+1,redAIColumn[aiIndex]]<>1) then
             redAIrow[aiIndex] := redAIrow[aiIndex] + 1
           else if (randomAIMovingCounter = 3) and (maze[redAIrow[aiIndex],redAIColumn[aiIndex]-1]<>1) then
             redAIcolumn[aiIndex] := redAIcolumn[aiIndex] - 1
           else if (randomAIMovingCounter = 4) and (maze[redAIrow[aiIndex],redAIColumn[aiIndex]+1]<>1) then
             redAIcolumn[aiIndex] := redAIcolumn[aiIndex] + 1;
           if (redAIColumn[aiIndex] = player2Column) and (redAIRow[aiIndex] = player2Row) then
             begin
               ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
               redAIColumn[aiIndex] := defaultRedAIColumn[aiIndex];
               redAIRow[aiIndex] := defaultRedAIRow[aiIndex];
               if ServerSocket1.Socket.ActiveConnections = 1 then
                 ServerSocket1.Socket.Connections[0].SendText('r' + IntToStr(aiIndex));
               eventLabel.caption := enemyPlayerName + ' got captured by your hired ninjas!';
               eventTimer.Enabled := true;
               eventLabel.Font.Color:=clRed;
             end;
         end;
     end
   else
     begin
       for aiIndex:= 1 to 6 do
         begin
           if (redAIcolumn[aiIndex] > player2column)and(maze[redAIrow[aiIndex],redAIColumn[aiIndex]-1]<>1)  then
             begin
               redAIcolumn[aiIndex] := redAIColumn[aiIndex] - 1;
             end
           else if (redAIColumn[aiIndex] < player2column) and(maze[redAIrow[aiIndex],redAIColumn[aiIndex]+1]<>1)  then
             begin
               redAIColumn[aiIndex] := redAIcolumn[aiIndex] + 1;
             end
           else if (redAIrow[aiIndex] > player2row) and (maze[redAIrow[aiIndex]-1,redAIColumn[aiIndex]]<>1) then
             begin
               RedAIrow[aiIndex] := redAIrow[aiIndex] - 1;
             end
           else if (redAIrow[aiIndex] < player2row)and(maze[redAIrow[aiIndex]+1,redAIColumn[aiIndex]]<>1)  then
             begin
               redAIrow[aiIndex] := redAIrow[aiIndex] + 1;
             end;
           if (redAIColumn[aiIndex] = player2Column) and (redAIRow[aiIndex] = player2Row) then
             begin
               ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
               redAIColumn[aiIndex] := defaultRedAIColumn[aiIndex];
               redAIRow[aiIndex] := defaultRedAIRow[aiIndex];
               if ServerSocket1.Socket.ActiveConnections = 1 then
                 ServerSocket1.Socket.Connections[0].SendText('r' + IntToStr(aiIndex));
               eventLabel.caption := enemyPlayerName + ' got captured by your hired ninjas!';
               eventTimer.Enabled := true;
               eventLabel.Font.Color:=clRed;
            end;
         end;   
  end;
  invalidate;
end;

procedure TMainForm.blueAItimerTimer(Sender: TObject);
var
 aiindex:integer;
begin
   if redStealthed = true then
     begin
       Inc(randomAIMovingCounter);
       if randomAIMovingCounter = 5 then
         randomAIMovingCounter := 1;
       for aiIndex := 1 to 6 do
         begin
           if (randomAIMovingCounter = 1) and (maze[blueAIrow[aiIndex]-1,blueAIColumn[aiIndex]]<>1) then
             blueAIrow[aiIndex] := blueAIrow[aiIndex] - 1
           else if (randomAIMovingCounter = 2) and (maze[blueAIrow[aiIndex]+1,blueAIColumn[aiIndex]]<>1) then
             blueAIrow[aiIndex] := blueAIrow[aiIndex] + 1
           else if (randomAIMovingCounter = 3) and (maze[blueAIrow[aiIndex],blueAIColumn[aiIndex]-1]<>1) then
             blueAIcolumn[aiIndex] := blueAIcolumn[aiIndex] - 1
           else if (randomAIMovingCounter = 4) and (maze[blueAIrow[aiIndex],blueAIColumn[aiIndex]+1]<>1) then
             blueAIcolumn[aiIndex] := blueAIcolumn[aiIndex] + 1;
           if (blueAIColumn[aiIndex] = playerColumn) and (blueAIRow[aiIndex] = playerRow) then
             begin
               ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
               blueAIColumn[aiIndex] := defaultBlueAIColumn[aiIndex];
               blueAIRow[aiIndex] := defaultBlueAIRow[aiIndex];
               if ServerSocket1.Socket.ActiveConnections = 1 then
                 ServerSocket1.Socket.Connections[0].SendText('b' + IntToStr(aiIndex));
              eventLabel.caption := 'You got captured by ' + enemyPlayerName + '''s hired ninjas!';
              eventTimer.Enabled := true;
              eventLabel.Font.Color := clBlue;
            end;
          end;
      end
   else
     begin
       for aiIndex:= 1 to 6 do
         begin
           if (blueAIcolumn[aiIndex] > playercolumn)and(maze[blueAIrow[aiIndex],blueAIColumn[aiIndex]-1]<>1)  then
             begin
               blueAIcolumn[aiIndex] := blueAIColumn[aiIndex] - 1;
             end
           else if (blueAIColumn[aiIndex] < playercolumn) and(maze[blueAIrow[aiIndex],blueAIColumn[aiIndex]+1]<>1)  then
             begin
               blueAIColumn[aiIndex] := blueAIcolumn[aiIndex] + 1;
             end
           else if (blueAIrow[aiIndex] > playerrow) and (maze[blueAIrow[aiIndex]-1,blueAIColumn[aiIndex]]<>1) then
             begin
               blueAIrow[aiIndex] := blueAIrow[aiIndex] - 1;
             end
           else if (blueAIrow[aiIndex] < playerrow)and(maze[blueAIrow[aiIndex]+1,blueAIColumn[aiIndex]]<>1)  then
             begin
               blueAIrow[aiIndex] := blueAIrow[aiIndex] + 1;
             end;
           if (blueAIColumn[aiIndex] = playerColumn) and (blueAIRow[aiIndex] = playerRow) then
             begin
               ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
               blueAIColumn[aiIndex] := defaultBlueAIColumn[aiIndex];
               blueAIRow[aiIndex] := defaultBlueAIRow[aiIndex];
               if ServerSocket1.Socket.ActiveConnections = 1 then
                 ServerSocket1.Socket.Connections[0].SendText('b' + IntToStr(aiIndex));
               eventLabel.caption := 'You got captured by ' + enemyPlayerName + '''s hired ninjas!';
               eventTimer.Enabled := true;
               eventLabel.Font.Color := clBlue;
             end;
         end;
     end;
  invalidate;
end;

procedure TMainForm.N12Click(Sender: TObject);
begin
  life := 1;
  NewGame(life);
end;

procedure TMainForm.N22Click(Sender: TObject);
begin
  life := 2;
  NewGame(life);
end;

procedure TMainForm.N32Click(Sender: TObject);
begin
  life := 3;
  NewGame(life);
end;

procedure TMainForm.N42Click(Sender: TObject);
begin
  life := 4;
  NewGame(life);
end;

procedure TMainForm.N52Click(Sender: TObject);
begin
  life := 5;
  NewGame(life);
end;

procedure TMainForm.N61Click(Sender: TObject);
begin
  life := 6;
  NewGame(life);
end;

procedure TMainForm.StrategicBattlefield1Click(Sender: TObject);
begin
  LoadUpMaze('maze01.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m01');
  NewGame(life);
  mapName := 'Strategic Battlefield';
end;

procedure TMainForm.Vortex1Click(Sender: TObject);
begin
  LoadUpMaze('maze02.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m02');
  NewGame(life);
  mapName := 'Vortex';
end;

procedure TMainForm.Deathmatch1Click(Sender: TObject);
begin
  LoadUpMaze('maze03.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m03');
  NewGame(life);
  mapName := 'Deathmatch';
end;

procedure TMainForm.OpenPlains1Click(Sender: TObject);
begin
  LoadUpMaze('maze04.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m04');
  NewGame(life);
  mapName := 'Open Plains';
end;

procedure TMainForm.Confusion1Click(Sender: TObject);
begin
  LoadUpMaze('maze05.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m05');
  NewGame(life);
  mapName := 'Confusion';
end;

procedure TMainForm.Labyrinth1Click(Sender: TObject);
begin
  LoadUpMaze('maze06.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m06');
  NewGame(life);
  mapName := 'Labyrinth';
end;

procedure TMainForm.SendClick(Sender: TObject);
begin
  if ChatMessage.Text <> '' then
    begin
      ChatMemo.Lines.Add(RedPlayerName.Text + ' says:');
      ChatMemo.Lines.Add(ChatMessage.Text);
      ChatMemo.Lines.Add('');
      if ServerSocket1.Socket.ActiveConnections = 1 then
        ServerSocket1.Socket.Connections[0].SendText('ç' + RedPlayerName.Text + 'ç' + ChatMessage.Text + 'ç');
      ChatMessage.Text := '';
      RedPlayerName.Enabled := false;
      ChatMessage.Enabled := false;
      Send.Enabled := false;
      ChatMemo.Enabled := false;
      ChatEnabled := false;
    end;
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
  RedPlayerName.Enabled := false;
  ChatMessage.Enabled := false;
  Send.Enabled := false;
  ChatMemo.Enabled := false;
  ChatEnabled := false;
end;

procedure TMainForm.PositionTimerTimer(Sender: TObject);
begin
  EnemyPlayerLabel.Caption := enemyPlayerName + ' is:';
  if blueStealthed = true then
    Bearing.Caption := 'Nowhere to be found'
  else if (playerRow > player2Row) and (playerColumn > player2Column) then
    Bearing.caption := 'Northwest of you'
  else if (player2Row > playerRow) and (playerColumn > player2Column) then
    Bearing.caption := 'Southwest of you'
  else if (player2Row > playerRow) and (player2Column > playerColumn) then
    Bearing.Caption := 'Southeast of you'
  else if (playerRow > player2Row) and (player2Column > playerColumn) then
    Bearing.Caption := 'Northeast of you'
  else if (playerRow > player2Row) then
    Bearing.Caption := 'North of you'
  else if (player2Row > playerRow) then
    Bearing.Caption := 'South of you'
  else if (playerColumn > player2Column) then
    Bearing.Caption := 'West of you'
  else
    Bearing.Caption := 'East of you';

  mapNameLabel.Caption := 'Map: ' + mapName;
end;

// Make the event label caption disapper after 3 seconds
procedure TMainForm.EventTimerTimer(Sender: TObject);
begin
   eventLabel.Caption:=' ';
   eventTimer.enabled:=false;
end;

procedure TMainForm.About2Click(Sender: TObject);
begin
  aboutBox.showModal;
end;

procedure TMainForm.Disaster1Click(Sender: TObject);
begin
  LoadUpMaze('maze07.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m07');
  NewGame(life);
  mapName := 'Disaster';
end;

procedure TMainForm.Torrential1Click(Sender: TObject);
begin
  LoadUpMaze('maze08.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m08');
  NewGame(life);
  mapName := 'Torrential';
end;

procedure TMainForm.Stadium1Click(Sender: TObject);
begin
  LoadUpMaze('maze09.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m09');
  NewGame(life);
  mapName := 'Stadium';
end;

procedure TMainForm.Spiral1Click(Sender: TObject);
begin
  LoadUpMaze('maze10.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m10');
  NewGame(life);
  mapName := 'Spiral';
end;

procedure TMainForm.Monoworld1Click(Sender: TObject);
begin
  LoadUpMaze('maze11.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m11');
  NewGame(life);
  mapName := 'Monoworld';
end;

procedure TMainForm.Haxed1Click(Sender: TObject);
begin
  LoadUpMaze('maze12.txt');
  if ServerSocket1.Socket.ActiveConnections = 1 then
    ServerSocket1.Socket.Connections[0].SendText('m12');
  NewGame(life);
  mapName := 'Haxed';
end;

procedure TMainForm.ChatMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    begin
      if ChatMessage.Text <> '' then
        begin
          ChatMemo.Lines.Add(RedPlayerName.Text + ' says:');
          ChatMemo.Lines.Add(ChatMessage.Text);
          ChatMemo.Lines.Add('');
          if ServerSocket1.Socket.ActiveConnections = 1 then
            ServerSocket1.Socket.Connections[0].SendText('ç' + RedPlayerName.Text + 'ç' + ChatMessage.Text + 'ç');
          ChatMessage.Text := '';
          RedPlayerName.Enabled := false;
          ChatMessage.Enabled := false;
          Send.Enabled := false;
          ChatMemo.Enabled := false;
          ChatEnabled := false;
        end;
    end;
end;

end.

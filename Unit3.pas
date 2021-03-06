unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ScktComp, StdCtrls, Math;

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
    ClientSocket1: TClientSocket;
    ServerChoice1: TMenuItem;
    Server1: TMenuItem;
    Timer1: TTimer;
    Label1: TLabel;
    redAITimer: TTimer;
    blueAITimer: TTimer;
    RedLifeCaption: TLabel;
    BlueLifeCaption: TLabel;
    BluePlayerName: TEdit;
    ChatMessage: TEdit;
    Send: TButton;
    ChatMemo: TMemo;
    PositionTimer: TTimer;
    EnemyPlayerLabel: TLabel;
    Bearing: TLabel;
    eventLabel: TLabel;
    eventTimer: TTimer;
    N1: TMenuItem;
    Instructions1: TMenuItem;
    Bevel2: TBevel;
    mapNameLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Server1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure redAITimerTimer(Sender: TObject);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure blueAITimerTimer(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure PositionTimerTimer(Sender: TObject);
    procedure eventTimerTimer(Sender: TObject);
    procedure Instructions1Click(Sender: TObject);
    procedure ChatMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure LoadUpMaze(fileName : String);
    procedure ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn : Integer);
    procedure ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column : Integer);
    procedure NewGame(life:integer);
  public
    maze : array[1..100, 1..100] of Integer;
    playerRow : Integer;
    playerColumn : Integer;
    player2Row : Integer;
    player2Column : Integer;
    defaultPlayerRow : Integer;
    defaultPlayer2Row : Integer;
    defaultPlayerColumn : Integer;
    defaultPlayer2Column : Integer;
    blueAIBitmap : TBitmap;
    redAIBitmap : TBitmap;
    visionUpgradeBitmap : tBitmap;
    mazeBitmaps : array [0..4] of TBitmap;
    playerBitmap : TBitmap;
    player2Bitmap : TBitmap;
    cellWidth, cellHeight : Integer;
    redFlagCapture, blueFlagCapture : boolean;
    redLife, blueLife : integer;
    redAIRow: array[1..6] of Integer;
    redAIColumn : array[1..6] of Integer;
    blueAIRow: array[1..6] of Integer;
    blueAIColumn : array[1..6] of Integer;
    defaultRedAIRow: array[1..6] of integer;
    defaultRedAIColumn : array[1..6] of Integer;
    defaultBlueAIRow: array[1..6] of integer;
    defaultBlueAIColumn : array[1..6] of Integer;
    ChatEnabled : boolean;
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
    stealth2Row, stealth2Column : integer;
  end;

var
  MainForm: TMainForm;

implementation

uses Unit2, Unit7;

{$R *.dfm}

procedure TMainForm.NewGame(life:integer);
begin
  Bevel2.Width := 360;
  Bevel2.Height := 360;
  visionAmount := 4;
  blueLife := life;
  redLife := life;
  Timer1.Enabled := true;
  Label1.Visible := true;
  Label1.Caption := '5';
  blueAITimer.Enabled := false;
  redAITimer.Enabled := false;
  RedLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(redLife);
  BlueLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(blueLife);
  redStealthed := false;
  blueStealthed := false;
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
  player2Column := defaultPlayer2Column;
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
   AssignFile(mazeFile, 'Mazes\' + fileName);
   Reset(mazeFile);
   Readln(mazeFile, noOfRows);
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
   ClientSocket1.Port := 2310;
   ChatEnabled := false;
   DoubleBuffered := true;
   enemyPlayerName := 'Red Player';
   visionAmount := 4;
   mapName := 'Strategic Battlefield';

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

   NewGame(redLife);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   // Free up the bitmap images
   playerBitmap.Free;
   player2Bitmap.Free;
   mazeBitmaps[PATH].Free;
   mazeBitmaps[BRICK].Free;
end;

// Repaints the form
// Needed since we are drawing the bitmaps on the form
// instead of placing TImage objects on the form
procedure TMainForm.FormPaint(Sender: TObject);
var
   row, column: Integer;
   xPos, yPos : Integer;
   index : integer;
   startRow, startColumn : integer;
   endRow, endColumn : integer;
begin
   startRow := Max(player2Row - visionAmount, 1);
   startColumn := Max(player2Column - visionAmount, 1);
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
   if (playerColumn >= startColumn) and (playerColumn <= endColumn) and (playerRow >= startRow) and (playerRow <= endRow) then
     Canvas.Draw(xPos, yPos,playerBitmap);

   xPos := (player2Column-startColumn)* cellWidth;
   yPos := (player2Row-startRow)* cellHeight;
   Canvas.Draw(xPos, yPos,player2Bitmap);

   xPos := (glassesColumn-startColumn)* cellWidth;
   yPos := (glassesRow-startRow)* cellHeight;
   if (glassesColumn >= startColumn) and (glassesColumn <= endColumn) and (glassesRow >= startRow) and (glassesRow <= endRow) then
     Canvas.Draw(xPos, yPos, visionUpgradeBitmap);

   xPos := (glasses2Column-startColumn)* cellWidth;
   yPos := (glasses2Row-startRow)* cellHeight;
   if (glasses2Column >= startColumn) and (glasses2Column <= endColumn) and (glasses2Row >= startRow) and (glasses2Row <= endRow) then
     Canvas.Draw(xPos, yPos, visionUpgradeBitmap);

   xPos := (stealthColumn-startColumn)* cellWidth;
   yPos := (stealthRow-startRow)* cellHeight;
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
begin
   oldRow := player2Row;
   oldColumn := player2Column;
   // Respond to each arrow key
   case Key of
      VK_LEFT :
         dec(player2Column);
      VK_RIGHT :
         inc(player2Column);
      VK_UP :
         dec(player2Row);
      VK_DOWN :
         inc(player2Row);
      Ord('A') :
         Dec(player2Column);
      Ord('D') :
         inc(player2Column);
      Ord('W') :
         dec(player2Row);
      Ord('S') :
         inc(player2Row);
      VK_SPACE :
         begin
           if ChatEnabled = false then
             begin
               BluePlayerName.Enabled := true;
               ChatMessage.Enabled := true;
               Send.Enabled := true;
               ChatMemo.Enabled := true;
               ChatEnabled := true;
              end
           else if ChatEnabled = true then
             begin
               BluePlayerName.Enabled := false;
               ChatMessage.Enabled := false;
               Send.Enabled := false;
               ChatMemo.Enabled := false;
               ChatEnabled := false;
             end;
         end;
     end;
   if maze[player2Row, player2Column] = 1 then
     begin
       player2Row := oldRow;
       player2Column := oldColumn;
     end
   else
     begin
       if blueStealthed = true then
         begin
         end
       else if (KEY = VK_LEFT) or (KEY = Ord('A')) then
         begin
           if redFlagCapture = true then
             player2Bitmap.LoadFromFile('bluedudewithflagleft.bmp')
           else
             player2Bitmap.LoadFromFile('bluedudeleft.bmp');
         end
       else if (KEY = VK_RIGHT) or (KEY = Ord('D')) then
         begin
           if redFlagCapture = true then
             player2Bitmap.LoadFromFile('bluedudewithflagright.bmp')
           else
             player2Bitmap.LoadFromFile('blueduderight.bmp');
         end;
       if (player2Row < 10) and (player2Column < 10) then
         ClientSocket1.Socket.SendText('p0' + IntToStr(player2Row) + '0' + IntToStr(player2Column))
       else if player2Row < 10 then
         ClientSocket1.Socket.SendText('p0' + IntToStr(player2Row) + IntToStr(player2Column))
       else if player2Column < 10 then
         ClientSocket1.Socket.SendText('p' + IntToStr(player2Row) + '0' + IntToStr(player2Column))
       else
         ClientSocket1.Socket.SendText('p' + IntToStr(player2Row) + IntToStr(player2Column));
     end;

   // If the player moved, redraw the player in the new position
   if (player2Row <> oldRow) or (player2Column <> oldColumn) then
   begin
       Invalidate;
   end;
   
   if maze[player2Row, player2Column] = 4 then
     begin
       blueStealthed := false;
       player2Bitmap.LoadFromFile('bluedudewithflag.bmp');
       mazeBitmaps[REDFLAG].LoadFromFile('flagpod.bmp');
       redFlagCapture := true;
       eventLabel.caption := 'You got ' + enemyPlayerName + '''s flag!';
       eventTimer.Enabled := true;
       eventLabel.Font.Color := clBlue;
     end;

  if (redFlagCapture = true) and (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
     begin
       ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
       ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
       eventLabel.caption := 'You both got captured!';
       eventTimer.Enabled := true;
       eventLabel.Font.Color := clBlack;
     end
  else if (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
     begin
       ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
       eventLabel.caption := enemyPlayerName + ' got captured by you!';
       eventTimer.Enabled := true;
       eventLabel.Font.Color := clBlue;
     end
  else if (redFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
     begin
       ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
       eventLabel.caption := enemyPlayerName + ' captured you!';
       eventTimer.Enabled := true;
       eventLabel.Font.Color := clBlue;
     end
  else if (player2Row = glassesRow) and (player2Column = glassesColumn) then
    begin
      visionAmount := 5;
      glassesRow := 0;
      glassesColumn := 0;
      Bevel2.Width := 440;
      Bevel2.Height := 440;
      eventLabel.caption := 'You got improved vision!';
      eventLabel.Font.Color := clBlue;
      eventTimer.Enabled := true;
    end
  else if (player2Row = glasses2Row) and (player2Column = glasses2Column) then
    begin
      visionAmount := 5;
      glasses2Row := 0;
      glasses2Column := 0;
      Bevel2.Width := 440;
      Bevel2.Height := 440;
      eventLabel.caption := 'You got improved vision!';
      eventLabel.Font.Color := clBlue;
      eventTimer.Enabled := true;
    end
  else if (player2Row = stealthRow) and (player2Column = stealthColumn) then
     begin
       stealthRow := 0;
       stealthRow := 0;
       eventLabel.caption := 'You become stealthier...';
       eventLabel.Font.Color := clBlue;
       eventTimer.Enabled := true;
       blueStealthed := true;
       player2Bitmap.LoadFromFile('rednpc.bmp');
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
      eventLabel.caption := 'You captured ' + enemyPlayerName + '''s flag!';
      eventLabel.Font.Color := clBlue;
      eventTimer.Enabled := true;
      if redLife = 0 then
        ShowMessage('You win');
    end;
  invalidate;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientSocket1.Active := false;
end;

procedure TMainForm.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  direction : string;
  index : Integer;
  index2 : integer;
begin
  direction := Socket.ReceiveText;
  index2 := 0;

  for index := 1 to length(direction) do
  begin
    if direction[index] = '�' then
      begin
        for index2 := index + 1 to Length(direction) - 1 do
          begin
            if direction[index2] = '�' then
              begin
                ChatMemo.Lines.Add(Copy(direction, index + 1, index2 - 2) + ' says:');
                enemyPlayerName := Copy(direction, index + 1, index2 - 2);
                ChatMemo.Lines.Add(Copy(direction, index2 + 1, Length(direction) - index2 - 1));
                ChatMemo.Lines.Add('');
              end;
          end;
      end
    else if (direction[index] = 'r') and (index2 = 0) then
      begin
        ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
        redAIColumn[StrToInt(direction[index + 1])] := defaultRedAIColumn[StrToInt(direction[index + 1])];
        redAIRow[StrToInt(direction[index + 1])] := defaultRedAIRow[StrToInt(direction[index + 1])];
        eventLabel.caption := 'You got captured by ' + enemyPlayerName + '''s hired ninjas!';
        eventTimer.Enabled := true;
        eventLabel.Font.Color := clRed;
      end
    else if (direction[index] = 'b') and (index2 = 0) then
      begin
        ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
        blueAIColumn[StrToInt(direction[index + 1])] := defaultBlueAIColumn[StrToInt(direction[index + 1])];
        blueAIRow[StrToInt(direction[index + 1])] := defaultBlueAIRow[StrToInt(direction[index + 1])];
        eventLabel.caption := enemyPlayerName + ' got captured by your hired ninjas!';
        eventTimer.Enabled := true;
        eventLabel.Font.Color:=clBlue;
      end
    else if (direction[index] = 'g') and (index2 = 0) then
      begin
        if direction[index + 1] = '1' then
          begin
            glassesRow := StrToInt(Copy(direction, index + 2, 2));
            glassesColumn := StrToInt(Copy(direction, index + 4, 2));
          end
        else if direction[index + 1] = '2' then
          begin
            glasses2Row := StrToInt(Copy(direction, index + 2, 2));
            glasses2Column := StrToInt(Copy(direction, index + 4, 2));
          end;
      end
    else if (direction[index] = 's') and (index2 = 0) then
      begin
        stealthRow := StrToInt(Copy(direction, index + 1, 2));
        stealthColumn := StrToInt(Copy(direction, index + 3, 2));
      end
    else if (direction[index] = 'p') and (index2 = 0) then
      begin
        playerRow := StrToInt(Copy(direction, index + 1, 2));
        playerColumn := StrToInt(Copy(direction, index + 3, 2));

        if maze[playerRow, playerColumn] = BLUEFLAG then
          begin
            redStealthed := false;
            playerBitmap.LoadFromFile('reddudewithflag.bmp');
            mazeBitmaps[BLUEFLAG].LoadFromFile('flagpod.bmp');
            blueFlagCapture := true;
            eventLabel.caption := enemyPlayerName + ' has taken your flag!';
            eventLabel.Font.Color := clRed;
            eventTimer.Enabled := true;
            Invalidate;
          end;
        if (redFlagCapture = true) and (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
          begin
            ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
            ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
            eventLabel.caption := 'You both got captured!';
            eventTimer.Enabled := true;
            eventLabel.Font.Color := clBlack;
          end
        else if (redFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
          begin
            ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
            eventLabel.caption := 'You got captured by ' + enemyPlayerName + '!';
            eventTimer.Enabled := true;
            eventLabel.Font.Color := clRed;
          end
        else if (blueFlagCapture = true) and (playerRow = player2Row) and (playerColumn = player2Column) then
          begin
            ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
            eventLabel.caption := enemyPlayerName + ' has been captured by you!';
            eventTimer.Enabled := true;
            eventLabel.Font.Color := clBlue;
          end
        else if (playerRow = glassesRow) and (playerColumn = glassesColumn) then
            begin
              glassesRow := 0;
              glassesColumn := 0;
              Invalidate;
            end
        else if (playerRow = glasses2Row) and (playerColumn = glasses2Column) then
            begin
              glasses2Row := 0;
              glasses2Column := 0;
              Invalidate;
            end
        else if (playerRow = stealthRow) and (playerColumn = stealthColumn) then
            begin
              stealthRow := 0;
              stealthColumn := 0;
              playerBitmap.LoadFromFile('bluenpc.bmp');
              redStealthed := true;
              Invalidate;
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
            eventLabel.caption := enemyPlayerName + ' has captured your flag!';
            eventLabel.Font.Color := clRed;
            eventTimer.Enabled := true;
            BlueLifeCaption.Caption := 'Remaining Flags: ' + IntToStr(blueLife);
            if blueLife = 0 then
              ShowMessage('You lose');
          end;
      end
    else if (index2 < 1) then
      begin
        if (direction[index] = 'm') then
          begin
            LoadUpMaze('maze' + Copy(direction, index + 1, 2) + '.txt');
            if Copy(direction, index + 1, 2) = '01' then
              mapName := 'Strategic Battlefield'
            else if Copy(direction, index + 1, 2) = '02' then
              mapName := 'Vortex'
            else if Copy(direction, index + 1, 2) = '03' then
              mapName := 'Deathmatch'
            else if Copy(direction, index + 1, 2) = '04' then
              mapName := 'Open Plains'
            else if Copy(direction, index + 1, 2) = '05' then
              mapName := 'Confusion'
            else if Copy(direction, index + 1, 2) = '06' then
              mapName := 'Labyrinth'
            else if Copy(direction, index + 1, 2) = '07' then
              mapName := 'Disaster'
            else if Copy(direction, index + 1, 2) = '08' then
              mapName := 'Torrential'
            else if Copy(direction, index + 1, 2) = '09' then
              mapName := 'Stadium'
            else if Copy(direction, index + 1, 2) = '10' then
              mapName := 'Spiral'
            else if Copy(direction, index + 1, 2) = '11' then
              mapName := 'Monoworld'
            else
              mapName := 'Haxed';
          end
        else if (direction[index] = 'Q') then
          begin
            NewGame(1);
            ChatMemo.Lines.Add(enemyPlayerName + ' changed the starting life to 1 and the map to ' + mapName + '! A new game is starting!');
            ChatMemo.Lines.Add('');
          end
        else if (direction[index] = 'W') then
          begin
            NewGame(2);
            ChatMemo.Lines.Add(enemyPlayerName + ' changed the starting life to 2 and the map to ' + mapName + '! A new game is starting!');
            ChatMemo.Lines.Add('');
          end
        else if (direction[index] = 'E') then
          begin
            NewGame(3);
            ChatMemo.Lines.Add(enemyPlayerName + ' changed the starting life to 3 and the map to ' + mapName + '! A new game is starting!');
            ChatMemo.Lines.Add('');
          end
        else if (direction[index] = 'R') then
          begin
            NewGame(4);
            ChatMemo.Lines.Add(enemyPlayerName + ' changed the starting life to 4 and the map to ' + mapName + '! A new game is starting!');
            ChatMemo.Lines.Add('');
          end
        else if (direction[index] = 'T') then
          begin
            NewGame(5);
            ChatMemo.Lines.Add(enemyPlayerName + ' changed the starting life to 5 and the map to ' + mapName + '! A new game is starting!');
            ChatMemo.Lines.Add('');
          end
        else if (direction[index] = 'Y') then
          begin
            NewGame(6);
            ChatMemo.Lines.Add(enemyPlayerName + ' changed the starting life to 6 and the map to ' + mapName + '! A new game is starting!');
            ChatMemo.Lines.Add('');
          end
        else if direction[index] = 't' then
          begin
            Label1.Visible := true;
            Label1.Caption := '5';
            Timer1.Enabled := true;
          end;
      end;
    Invalidate;
  end;
end;

procedure TMainForm.Server1Click(Sender: TObject);
var
  server : string;
begin
  server := InputBox('Server Choice', 'Please enter your desired LAN server: ', 'LAN Server');
  ClientSocket1.Active := false;
  ClientSocket1.Host := server;
  ClientSocket1.Active := true;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  aiIndex:integer;
begin
  Label1.Caption := IntToStr(StrToInt(label1.Caption) - 1);
  if Label1.Caption = '0' then
    begin
      Timer1.Enabled := false;
      Label1.Visible := false;
      Label1.Caption := '5';
      ReturnRedPlayer(defaultPlayerRow, defaultPlayerColumn);
      ReturnBluePlayer(defaultPlayer2Row, defaultPlayer2Column);
      redAiTimer.Enabled := true;
      blueAITimer.Enabled := true;
      for aiIndex := 1 to 6 do
        begin
          redAIColumn[aiIndex] := defaultRedAIColumn[aiIndex];
          redAIRow[aiIndex] := defaultRedAIRow[aiIndex];
          blueAIColumn[aiIndex] := defaultBlueAIColumn[aiIndex];
          blueAIRow[aiIndex] := defaultBlueAIRow[aiIndex];
        end;
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
         end;   
  end;
  invalidate;
end;

procedure TMainForm.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
  server : string;
begin
  ShowMessage('Your LAN server address is invalid!');
  server := InputBox('Server Choice', 'Please enter your desired LAN server: ', 'LAN Server');
  ClientSocket1.Active := false;
  ClientSocket1.Host := server;
  ClientSocket1.Active := true;
end;

procedure TMainForm.blueAITimerTimer(Sender: TObject);
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
         end;
     end;
  invalidate;
end;

procedure TMainForm.SendClick(Sender: TObject);
begin
  if ChatMessage.Text <> '' then
    begin
      ChatMemo.Lines.Add(BluePlayerName.Text + ' says:');
      ChatMemo.Lines.Add(ChatMessage.Text);
      ChatMemo.Lines.Add('');
      ClientSocket1.Socket.SendText('�' + BluePlayerName.Text + '�' + ChatMessage.Text + '�');
      ChatMessage.Text := '';
    end;
      BluePlayerName.Enabled := false;
      ChatMessage.Enabled := false;
      Send.Enabled := false;
      ChatMemo.Enabled := false;
      ChatEnabled := false;
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
  BluePlayerName.Enabled := false;
  ChatMessage.Enabled := false;
  Send.Enabled := false;
  ChatMemo.Enabled := false;
  ChatEnabled := false;
end;

procedure TMainForm.PositionTimerTimer(Sender: TObject);
begin
  EnemyPlayerLabel.Caption := enemyPlayerName + ' is:';
  if redStealthed = true then
    Bearing.Caption := 'Nowhere to be found'
  else if (playerRow > player2Row) and (playerColumn > player2Column) then
    Bearing.caption := 'Southeast of you'
  else if (player2Row > playerRow) and (playerColumn > player2Column) then
    Bearing.caption := 'Northeast of you'
  else if (player2Row > playerRow) and (player2Column > playerColumn) then
    Bearing.Caption := 'Northwest of you'
  else if (playerRow > player2Row) and (player2Column > playerColumn) then
    Bearing.Caption := 'Southwest of you'
  else if (playerRow > player2Row) then
    Bearing.Caption := 'South of you'
  else if (player2Row > playerRow) then
    Bearing.Caption := 'North of you'
  else if (playerColumn > player2Column) then
    Bearing.Caption := 'East of you'
  else
    Bearing.Caption := 'West of you';
end;

procedure TMainForm.eventTimerTimer(Sender: TObject);
begin
   eventLabel.Caption:=' ';
   eventTimer.enabled:=false;
end;

procedure TMainForm.Instructions1Click(Sender: TObject);
begin
 instructions2.showModal
end;

procedure TMainForm.ChatMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    begin
      if ChatMessage.Text <> '' then
        begin
          ChatMemo.Lines.Add(BluePlayerName.Text + ' says:');
          ChatMemo.Lines.Add(ChatMessage.Text);
          ChatMemo.Lines.Add('');
          ClientSocket1.Socket.SendText('�' + BluePlayerName.Text + '�' + ChatMessage.Text + '�');
          ChatMessage.Text := '';
        end;
          BluePlayerName.Enabled := false;
          ChatMessage.Enabled := false;
          Send.Enabled := false;
          ChatMemo.Enabled := false;
          ChatEnabled := false;
    end;
end;

end.

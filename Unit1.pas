// Convert Merlin32 source files
// to Merlin8/16 source fils
// ready to be assembled on an Apple II using Merlin Assembler

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, Vcl.ComCtrls ;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
       procedure WMDropFiles(var msg : TMessage); message WM_DROPFILES;
       procedure SetOutput;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TextfileSize(const name: string): LongInt;
var
  SRec: TSearchRec;
begin
  if FindFirst(name, faAnyfile, SRec) = 0 then
  begin
    Result := SRec.Size;
    FindClose(SRec);
  end
  else
    Result := 0;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  filin, filout : textfile;
  space : boolean;
  c : char;
  s : string;
  i : integer;
  inputlength, readbytes : longint;

begin
  try
    try
    // init. action
    button1.Enabled := false;
    ProgressBar1.Visible := true;
    // get input file size
    inputlength :=  TextfileSize(Edit1.Text);
    // file size = 0 : exit
    if inputlength=0 then
    raise Exception.Create('File size = 0');

    assignfile(filin,Edit1.Text);
    reset(filin);
    assignfile(filout,Edit2.Text);
    rewrite(filout);

    space := false;
    ProgressBar1.Position := 0;
    readbytes := 0;

    while not(eof(filin))  do
      begin
        readln(filin,s);
        readbytes := readbytes + length(s);

        // update progreebar
        ProgressBar1.Position :=  (readbytes * 100) div  inputlength;
        Application.ProcessMessages;


        // case of empty string
        if s = '' then
          begin
            write(filout, chr(13));
          end
          else
            begin
            // replace tabs by spaces
            for i := 1 to length(s) do if s[i] = chr(9) then   s[i] := ' ';

            // case of comment
            c :=  trim(s)[1];
            if (c = '*') or (c = ';') then
              begin
                write(filout, trim(s)+chr(13));
              end

              else
              begin
                // process string
                space := false;
                for i := 1 to length(s) do
                // case of spaces : no more than 2 consecutive spaces
                if  s[i] = ' ' then
                  begin
                    if space = false then    // no space character before
                      begin
                        write(filout,' ') ;
                        space := true;       // update flag for next char.
                      end
                    else  space := true;     // useless
                  end
                  else
                // char <> space
                  begin
                    space := false;         // update flag for next char.
                    if s[i] <> chr(10) then write(filout,s[i]);  // don't write line feed char.
                  end;
                  write(filout,chr(13));   // return at the end of line
              end;

        end;
    end;

    ProgressBar1.Position := 100;
    closefile(filin);
    closefile(filout);
    Application.MessageBox('Job''s done.','',0);
    ProgressBar1.Visible := false;

    except
      begin
        Application.MessageBox('Error !!','',0);
        ProgressBar1.Visible := false;
      end;

    end;
    finally
      begin
       button1.Enabled := true;
       ProgressBar1.Position := 0;
      end;

    end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, true);
end;


// set output file name, from input file name :
// add 'A2' to input file name (before extention, typically  before : '.s')
// add  '#040000' at the end, for Ciderpress ( $04 : text file type, 0000 : aux type).
procedure TForm1.SetOutput;
var
  tempo : string;
  i, index : longint;
  found : boolean;
begin
  tempo := Edit1.Text;
  i := length(tempo);
  found := false;
  index := 0;
  repeat
    if tempo[i] = '.' then
    begin
      found := true;
      index := i;
    end;
    i:= i-1;
  until (i =0) or (found = true);

  Edit2.Text := '';

  if index=0 then  // if no '.' found
  begin
    Edit2.Text := Edit1.Text +'A2.s#040000';
  end
  else
  begin
    for i:= 1 to index-1 do
      Edit2.Text := Edit2.Text + tempo[i];
    // siffixe = A2 for output file
    Edit2.Text := Edit2.Text + 'A2';
    for i:= index to length(tempo) do
      Edit2.Text := Edit2.Text + tempo[i] ;
      // extension for Ciderpress
    Edit2.Text := Edit2.Text + '#040000';
  end;
end;


// drag n drop file
procedure TForm1.WMDropFiles(var msg : TMessage);
var
  hand: THandle;
  nbFich, i : integer;
  buf:array[0..254] of Char;
  begin
    hand:=msg.wParam;
    nbFich:= DragQueryFile(hand, 4294967295, buf, 254);
    for i:= 0 to nbFich - 1 do
    begin
      DragQueryFile(hand, i, buf, 254);
      Edit1.Text := (buf);
    end;
    DragFinish(hand);
    SetOutput;
end;


end.

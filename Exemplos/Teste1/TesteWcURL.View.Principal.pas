unit TesteWcURL.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TViewPrincipal = class(TForm)
    btnTesteBasico: TButton;
    pgctrlRespostas: TPageControl;
    tbshRespostas: TTabSheet;
    memResposta: TMemo;
    procedure btnTesteBasicoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  _LISTA_ANIMAS = (laCachorro {0}, laGato {1}, laRato {2});


var
  ViewPrincipal: TViewPrincipal;

implementation
uses
     AES_WcURL;

{$R *.dfm}

procedure TViewPrincipal.btnTesteBasicoClick(Sender: TObject);
// Tentando reproduzir em Delphi o exemplo em
// https://gist.github.com/alghanmi/c5d7b761b2c9ab199157
// Feito em C
var
     LCURL: CURL;
     LRES: CURLcode;
     readBuffer: String;
begin
     LCURL := curl_easy_init;
     if Assigned(LCURL) then
     Begin
          // https://stackoverflow.com/questions/4293625/curl-curle-couldnt-resolve-host-in-debug-mode
          curl_easy_setopt(LCURL, CURLOPT_URL, pAnsiChar('http://teste.com.br'));
          curl_easy_setopt(LCURL, CURLOPT_CUSTOMREQUEST, 'GET');
          LRES := curl_easy_perform(LCURL);

          if LRES = CURLE_OK then
          Begin
               showmessage('Houve resposta ;)');
               // tratar resposta...
          End;

          curl_easy_cleanup(LCURL);
     End;
end;

end.

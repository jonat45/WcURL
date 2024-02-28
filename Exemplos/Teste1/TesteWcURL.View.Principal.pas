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
     LNum,
     iNum1,
     iNum2: Integer;
     pEnderecoNum: ^Integer;

     LCURL: CURL;
     LRES: CURLcode;
     readBuffer: String;
begin
//     LNum := Integer(_LISTA_ANIMAS.laRato);
//
//     iNum1 := 1;
//     iNum2 := 2;

     //showmessage(LIBCURL_VERSION);
//     showmessage(format('Num1: %d | Num2: %d', [iNum1, iNum2]));
//     showmessage(format('Endereço de memória de Num1: %d | Endereço de memória de Num2: %d', [Integer(@iNum1), Integer(@iNum2)]));
//
//     pEnderecoNum := @iNum1;
//     showmessage(format('Endereço de memória de Num1: %d (%d)', [Integer(pEnderecoNum), Integer(pEnderecoNum^)]));
//
//     pEnderecoNum := @iNum2;
//     showmessage(format('Endereço de memória de Num2: %d (%d)', [Integer(pEnderecoNum), Integer(pEnderecoNum^)]));

     LCURL := curl_easy_init;

     if Assigned(LCURL) then
     Begin
          showmessage('Instanciado com sucesso!');
     End;
end;

end.

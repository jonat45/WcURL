program TesteWcURL;

uses
  Vcl.Forms,
  TesteWcURL.View.Principal in 'TesteWcURL.View.Principal.pas' {ViewPrincipal},
  AES_WcURL in 'AES_WcURL.pas',
  AES_WcURL_EASY in 'AES_WcURL_EASY.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.

program TesteWcURL;

uses
  Vcl.Forms,
  TesteWcURL.View.Principal in 'TesteWcURL.View.Principal.pas' {ViewPrincipal},
  AES_WcURL in '..\..\curl\AES_WcURL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.

@ECHO OFF
ECHO * $Id: .lint.bat 344 2013-07-20 07:49:34Z pirolix $

@SET MT_HOME="X:\Project\MovableType\src\5.12"
echo ^* Use MT in %MT_HOME%

SET PERL_OPT=-C

echo ^* Checking Perl Scripts ...
FOR /F %%I IN ('DIR /B /S *.pm') DO perl ^
    %PERL_OPT% ^
    -I%MT_HOME%/lib ^
    -I%MT_HOME%/extlib ^
    -Ilib ^
    -Iextlib ^
    %%I

echo ^* Checking Perl Modules ...
FOR /F %%I IN ('DIR /B /S *.pl') DO perl ^
    %PERL_OPT% ^
    -I%MT_HOME%/lib ^
    -I%MT_HOME%/extlib ^
    -Ilib ^
    -Iextlib ^
    %%I

PAUSE

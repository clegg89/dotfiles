@rem FILE: %FFILE%
@rem AUTHOR: C. Smith
@rem DESC: %HERE%
@echo off
setlocal

set self=%~nx0

@rem Skip function prototypes
goto main

@rem FUNCTIONS

:main

:success
endlocal
goto :EOF

:error
echo %self% failed with error #%errorlevel%
exit /b %errorlevel%

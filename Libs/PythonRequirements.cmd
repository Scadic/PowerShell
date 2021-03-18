DIR /b /s | FINDSTR /i "PythonRequirements.cmd" > output.tmp
< output.tmp (SET /p pyreq=)
DEL output.tmp
DIR /b /s | FINDSTR /i "activate.bat" > output.tmp
< output.tmp (SET /p venv=)
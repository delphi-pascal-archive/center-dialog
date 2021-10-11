{*******************************************************************************
 Project   : Center Open|Save Dialog
 Date      : 13-08-2008
 Version   : 1.0
 Author    : Maks1509
 URL       : www.maks1509.webhost.ru
 Copyright : Copyright (c) 2008 Maks1509
*******************************************************************************}

program example;

uses
  Windows, Messages, CommDlg;

const
  RC_DIALOG = 101;
  ID_PATH   = 101;
  ID_OPEN   = 102;

var
  ofn      : TOpenFileName;
  FilePath : Array[0..MAX_PATH - 1] of Char;

{$R example.res}

function CenterWindow(hWindow : THandle) : Boolean;
var
  WndRect : TRect;
  iWidth  : Integer;
  iHeight : Integer;
begin
  GetWindowRect(hWindow, WndRect);
  iWidth := WndRect.Right - WndRect.Left;
  iHeight := WndRect.Bottom - WndRect.Top;
  WndRect.Left := (GetSystemMetrics(SM_CXSCREEN) - iWidth) div 2;
  WndRect.Top := (GetSystemMetrics(SM_CYSCREEN) - iHeight) div 2;
  MoveWindow(hWindow, WndRect.Left, WndRect.Top, iWidth, iHeight, FALSE);
  Result := TRUE;
end;

function FuncDlgHook(Wnd : HWND; uMsg : Cardinal; wParam : wParam; lParam : lParam) : UINT; stdcall;
begin
  Result := 0;
  case uMsg of
    WM_INITDIALOG : CenterWindow(GetParent(Wnd));
  end;
end;

function MainDlgFunc(hWnd : THandle; uMsg : UINT; wParam : wParam; lParam : lParam) : BOOL; stdcall;
begin
  Result := TRUE;
  case uMsg of
    WM_COMMAND:
      case wParam of
        ID_OPEN :
          begin
            FillChar(FilePath, SizeOf(FilePath), 0);
            FillChar(ofn, SizeOf(ofn), 0);
            ofn.lStructSize := SizeOf(TOpenFileName);
            ofn.hwndOwner   := hWnd;
            ofn.hInstance   := hInstance;
            ofn.lpstrFilter := '(*.*)'#0'*.*'#0#0;
            ofn.lpstrFile   := FilePath;
            ofn.nMaxFile    := MAX_PATH;
            ofn.lpfnHook    := FuncDlgHook;
            ofn.Flags       := OFN_DONTADDTORECENT or OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY or OFN_ENABLEHOOK or OFN_ENABLESIZING;
            if GetOpenFileName(ofn) then
              SendMessage(GetDlgItem(hWnd, ID_PATH), WM_SETTEXT, 0, Integer(PChar(ofn.lpstrFile)));
          end;
      end;
    WM_CLOSE : PostQuitMessage(0);
  else
    Result := FALSE;
  end;
end;

begin
   DialogBoxParam(hInstance, MAKEINTRESOURCE(RC_DIALOG), 0, @MainDlgFunc, 0);
   ExitProcess(hInstance);
end.

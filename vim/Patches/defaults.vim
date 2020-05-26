--- vim82-64/runtime/defaults.vim	2019-10-27 17:41:21.000000000 +0000
+++ vim82-64/runtime/defaults.vim	2020-05-20 10:51:16.552043288 +0000
@@ -77,13 +77,17 @@ inoremap <C-U> <C-G>u<C-U>
 " can position the cursor, Visually select and scroll with the mouse.
 " Only xterm can grab the mouse events when using the shift key, for other
 " terminals use ":", select text and press Esc.
-if has('mouse')
-  if &term =~ 'xterm'
-    set mouse=a
-  else
-    set mouse=nvi
-  endif
-endif
+"
+" Disabled on SmartOS: this breaks usage of the mouse for bringing a selection
+" into the X clipboard, middle-click paste, etc.
+"
+"if has('mouse')
+"  if &term =~ 'xterm'
+"    set mouse=a
+"  else
+"    set mouse=nvi
+"  endif
+"endif
 
 " Switch syntax highlighting on when the terminal has colors or when using the
 " GUI (which always has colors).

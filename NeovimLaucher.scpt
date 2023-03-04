on run {input, parameters}
 if (count of input) > 0 then
  tell application "System Events"
   set runs to false
   try
    set p to application process "iTerm"
    set runs to true
   end try
  end tell
  
  tell application "iTerm"
   activate
   set numItems to the count of items of input
   set launchPaths to ""
   # 循环查找是否有意境打开的neovim
   repeat with w in windows
    repeat with t in tabs of w
     repeat with s in sessions of t
      if name of s contains "nvim" then
       set nvimRunning to true
       tell s
        repeat with x from 1 to numItems
         set filePath to quoted form of POSIX path of item x of input
         write text (":execute 'tabedit '.fnameescape(" & filePath & ")")
        end repeat
       end tell
       return
      end if
     end repeat
    end repeat
   end repeat
   # 如果没有就新建一个iTerm的tab打开文件
   tell current window
    set newTab to (create tab with default profile)
    tell newTab
     tell current session
      repeat with x from 1 to numItems
       set filePath to quoted form of POSIX path of item x of input
       set launchPaths to launchPaths & " " & filePath
      end repeat
      write text ("nvim -p " & launchPaths)
     end tell
    end tell
   end tell
  end tell
 end if
end run

-- 源码参考 https://github.com/garrettheath4/WiFi-Sync和https://github.com/BiggerHao/Internet-Sharing-Applescript
-- 我只是增加了一些注释，让人更容易看懂，以便于改动，修复了一些适应性问题，

-- 定义的常量
property Openwifi : "打开 Wi-Fi"
property WifiIsOpening : "Wi-Fi已打开"
property SharingIsOpening : "网络共享已打开"



-- on run argv 表示run方法，argv不限量参数，一般定义方法则是 to functionname(argument 1, argument 2...)
on run argv
	
	tell application "System Events"
		tell process "SystemUIServer"
			-- 菜单栏
			tell menu bar 1
				
				-- 给电脑一些反应时间
				delay 0.1
				-- 将菜单栏所有选项的描述名赋给数组变量menu_extras
				set menu_extras to value of attribute "AXDescription" of menu bar items
				
				-- 循环数组
				repeat with the_menu from 1 to the count of menu_extras
					-- 找到wifi时跳出循环
					if item the_menu of menu_extras contains "Wi-Fi" then exit repeat
				end repeat
				
				-- 打开wifi
				tell menu bar item the_menu
					
					(*
					用于打开wifi选择框
					此处比较耗时，还没有找到为什么
					*)
					perform action "AXPress"
					
					--将wifi菜单里第2项的标题赋给变量 wifiItem
					set wifiItem to the title of menu item 2 of menu 1 as text
					
					-- 如果wifiItem 是"打开 Wi-Fi"
					if wifiItem is Openwifi then
						say Openwifi
						
						-- 点击这个菜单项
						perform action "AXPress" of menu item Openwifi of menu 1
						perform action "AXPress"
					else
						say WifiIsOpening
						
					end if
				end tell
			end tell
		end tell
	end tell
	
	-- 告诉系统偏好设置
	tell application "System Preferences"
		-- 激活
		activate
		-- pane id "" 可以根据id找到共享首选项，鉴于我们并不知道所有的首选项id，可以使用名字找到，比如 pane "共享", pane "网络"
		-- reveal 则就是打开的意思了
		reveal (pane id "com.apple.preferences.sharing")
	end tell
	
	--设置偏好
	tell application "System Events"
		tell process "System Preferences"
			delay 1
			try
				-- select选中此行
				-- of这里应该从后向前看，第一个window -> 第一个group -> 第一个滚动块 -> 第一个表格 -> 第7行，我的第7行是互联网共享，可根据各自情况修改
				
				select row 7 of table 1 of scroll area 1 of group 1 of window 1
				-- 如果....的第7行的checkbox已被选中，需要先关闭才能继续选择来源
				
				if value of checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1 as boolean then
					
					-- 选择此行
					select row 7 of table 1 of scroll area 1 of group 1 of window 1
					-- 点选此行的checkbox
					
					click checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1
					-- 此时关闭共享
				end if
				
				-- 点击打开共享来源的弹出框
				click pop up button 1 of group 1 of window 1
				-- 选择共享来源pop框中的第2项
				click menu item 3 of menu 1 of pop up button 1 of group 1 of window 1
				-- 如果共享端口表中的第1行未被选中
				if not value of checkbox of row 1 of table 1 of scroll area 2 of group 1 of window 1 as boolean then
					-- 选择共享端口表中的第1行
					select row 1 of table 1 of scroll area 2 of group 1 of window 1
					-- 点击第1行的checkbox
					click checkbox of row 1 of table 1 of scroll area 2 of group 1 of window 1
					-- 此时第1行才被选中
				end if
				-- 点击此页的第一个group第一个按钮，即 wifi选项 按钮，之后弹出提示框
				click button 1 of group 1 of window 1
				-- 如果参数个数为2
				if the (count of item of argv) is 2 then
					-- 根据入参，分别设置网络名称，密码，密码验证。频段和安全性不属于text field, 因此不计入在内
					set value of text field 1 of sheet 1 of window 1 to item 1 of argv
					set value of text field 2 of sheet 1 of window 1 to item 2 of argv
					set value of text field 3 of sheet 1 of window 1 to item 2 of argv
				end if
				-- 点击确定
				click button 1 of sheet 1 of window 1
				delay 1
				-- 如果....的第7行的checkbox未被选中
				if not value of checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1 as boolean then
					-- 选择此行
					select row 7 of table 1 of scroll area 1 of group 1 of window 1
					-- 点选此行的checkbox
					click checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1
					delay 1
					-- 点击弹出框的第2个按钮
					click button 2 of sheet 1 of window 1
				end if
				delay 1
				-- 关闭系统设置页面
				tell application "System Preferences" to quit
				-- 提示网络共享已打开，1秒后自动关闭
				activate (display alert (SharingIsOpening) giving up after 1)
				say SharingIsOpening
				-- 出错时自动调用error方法
			on error err
				activate
				display alert "Couldn't toggle Internet Sharing." message err as critical
				return false
			end try
			
		end tell
	end tell
	
	
end run
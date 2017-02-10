-- Դ��ο� https://github.com/garrettheath4/WiFi-Sync��https://github.com/BiggerHao/Internet-Sharing-Applescript
-- ��ֻ��������һЩע�ͣ����˸����׿������Ա��ڸĶ����޸���һЩ��Ӧ�����⣬

-- ����ĳ���
property Openwifi : "�� Wi-Fi"
property WifiIsOpening : "Wi-Fi�Ѵ�"
property SharingIsOpening : "���繲���Ѵ�"



-- on run argv ��ʾrun������argv������������һ�㶨�巽������ to functionname(argument 1, argument 2...)
on run argv
	
	tell application "System Events"
		tell process "SystemUIServer"
			-- �˵���
			tell menu bar 1
				
				-- ������һЩ��Ӧʱ��
				delay 0.1
				-- ���˵�������ѡ��������������������menu_extras
				set menu_extras to value of attribute "AXDescription" of menu bar items
				
				-- ѭ������
				repeat with the_menu from 1 to the count of menu_extras
					-- �ҵ�wifiʱ����ѭ��
					if item the_menu of menu_extras contains "Wi-Fi" then exit repeat
				end repeat
				
				-- ��wifi
				tell menu bar item the_menu
					
					(*
					���ڴ�wifiѡ���
					�˴��ȽϺ�ʱ����û���ҵ�Ϊʲô
					*)
					perform action "AXPress"
					
					--��wifi�˵����2��ı��⸳������ wifiItem
					set wifiItem to the title of menu item 2 of menu 1 as text
					
					-- ���wifiItem ��"�� Wi-Fi"
					if wifiItem is Openwifi then
						say Openwifi
						
						-- �������˵���
						perform action "AXPress" of menu item Openwifi of menu 1
						perform action "AXPress"
					else
						say WifiIsOpening
						
					end if
				end tell
			end tell
		end tell
	end tell
	
	-- ����ϵͳƫ������
	tell application "System Preferences"
		-- ����
		activate
		-- pane id "" ���Ը���id�ҵ�������ѡ��������ǲ���֪�����е���ѡ��id������ʹ�������ҵ������� pane "����", pane "����"
		-- reveal ����Ǵ򿪵���˼��
		reveal (pane id "com.apple.preferences.sharing")
	end tell
	
	--����ƫ��
	tell application "System Events"
		tell process "System Preferences"
			delay 1
			try
				-- selectѡ�д���
				-- of����Ӧ�ôӺ���ǰ������һ��window -> ��һ��group -> ��һ�������� -> ��һ����� -> ��7�У��ҵĵ�7���ǻ����������ɸ��ݸ�������޸�
				
				select row 7 of table 1 of scroll area 1 of group 1 of window 1
				-- ���....�ĵ�7�е�checkbox�ѱ�ѡ�У���Ҫ�ȹرղ��ܼ���ѡ����Դ
				
				if value of checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1 as boolean then
					
					-- ѡ�����
					select row 7 of table 1 of scroll area 1 of group 1 of window 1
					-- ��ѡ���е�checkbox
					
					click checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1
					-- ��ʱ�رչ���
				end if
				
				-- ����򿪹�����Դ�ĵ�����
				click pop up button 1 of group 1 of window 1
				-- ѡ������Դpop���еĵ�2��
				click menu item 3 of menu 1 of pop up button 1 of group 1 of window 1
				-- �������˿ڱ��еĵ�1��δ��ѡ��
				if not value of checkbox of row 1 of table 1 of scroll area 2 of group 1 of window 1 as boolean then
					-- ѡ����˿ڱ��еĵ�1��
					select row 1 of table 1 of scroll area 2 of group 1 of window 1
					-- �����1�е�checkbox
					click checkbox of row 1 of table 1 of scroll area 2 of group 1 of window 1
					-- ��ʱ��1�вű�ѡ��
				end if
				-- �����ҳ�ĵ�һ��group��һ����ť���� wifiѡ�� ��ť��֮�󵯳���ʾ��
				click button 1 of group 1 of window 1
				-- �����������Ϊ2
				if the (count of item of argv) is 2 then
					-- ������Σ��ֱ������������ƣ����룬������֤��Ƶ�κͰ�ȫ�Բ�����text field, ��˲���������
					set value of text field 1 of sheet 1 of window 1 to item 1 of argv
					set value of text field 2 of sheet 1 of window 1 to item 2 of argv
					set value of text field 3 of sheet 1 of window 1 to item 2 of argv
				end if
				-- ���ȷ��
				click button 1 of sheet 1 of window 1
				delay 1
				-- ���....�ĵ�7�е�checkboxδ��ѡ��
				if not value of checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1 as boolean then
					-- ѡ�����
					select row 7 of table 1 of scroll area 1 of group 1 of window 1
					-- ��ѡ���е�checkbox
					click checkbox of row 7 of table 1 of scroll area 1 of group 1 of window 1
					delay 1
					-- ���������ĵ�2����ť
					click button 2 of sheet 1 of window 1
				end if
				delay 1
				-- �ر�ϵͳ����ҳ��
				tell application "System Preferences" to quit
				-- ��ʾ���繲���Ѵ򿪣�1����Զ��ر�
				activate (display alert (SharingIsOpening) giving up after 1)
				say SharingIsOpening
				-- ����ʱ�Զ�����error����
			on error err
				activate
				display alert "Couldn't toggle Internet Sharing." message err as critical
				return false
			end try
			
		end tell
	end tell
	
	
end run
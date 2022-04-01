_G.BanLanguage = _G.BanLanguage or {}

function BanLanguage:BlockedLetters()
	return "åäö"
end


function BanLanguage:Setup()
	BanLanguage:SetupHooks()
end


function BanLanguage:SetupHooks()
	if RequiredScript == "lib/managers/chatmanager" then
		Hooks:PostHook(
			ChatGui,
			"receive_message",
			"BanLanguage_ChatGui_receive_message",
			function(self, name, message, color, icon)
				BanLanguage:DetectLanguage(name, message)
			end
		)
	end
end


function BanLanguage:DetectLanguage(name, message)
	local letterCount = 0
	local blockedLetters = BanLanguage:BlockedLetters()

	for letter in blockedLetters:gmatch"." do
		if string.find(message, letter) then
			letterCount = letterCount + 1

			if letterCount > 2 then break
		end
	end

	if letterCount > 2 then
		log("[BANL]]: \t Blocked letters were detected.")
	else
		log("[BANL]]: \t No detection.")
	end
end


function BanLanguage:TryKickPlayer(name)
	if not managers.network or not managers.network:session() then
		log("[BANL]]: \t Network or Session could not be found.")
		return
	end

	local client_peer = managers.network:session():local_peer()
	local sender_peer = managers.network:session():peer_by_name(name)	

	if client_peer == sender_peer then
		log("[BANL]: \t Detection was triggered by you.")
		return
	end

	if Network.is_server() then
		managers.network:session():send_to_peers("kick_peer", sender_peer:id(), 2)
		managers.network:session():on_peer_kicked(sender_peer, sender_peer:id(), 2)
	end
end

BanLanguage:Setup()
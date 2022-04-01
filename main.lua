_G.BanLanguage = _G.BanLanguage or {}

function BanLanguage:BlockedLetters()
	return "åäö"
end

function BanLanguage:MaxAllowedLetters()
	return 2
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

	for i = 1, #blockedLetters do
		local c = blockedLetters:sub(i,i)
		if string.find(message, c) then
			letterCount = letterCount + 1

			if letterCount > BanLanguage:MaxAllowedLetters() then break end
		end
	end

	if letterCount > BanLanguage:MaxAllowedLetters() then
		BanLanguage:TryKickPlayer(name)
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
		log("[BANL]: \t" .. name .. " was kicked from the lobby")
	end
end

BanLanguage:Setup()
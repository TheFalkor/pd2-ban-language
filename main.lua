_G.BanLanguage = _G.BanLanguage or {}

function BanLanguage:Letters()
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
	if not managers.network or not managers.network:session() then
		log("[KR]: \t managers.network could not be found.")
		return
	end

	local client_peer = managers.network:session():local_peer()
	local sender_peer = managers.network:session():peer_by_name(name)

	if message == BanLanguage:Letters() then
		log("[KR]: \t it detected message? idk maybe")
	else
		log("[KR]: \t didnt detect?")
	end
end

BanLanguage:Setup()
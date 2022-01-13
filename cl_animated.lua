local loaded = false
local totalVipCars = 0
local animatedCars = {
	[`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://giphy.com/embed/fu1cAil49jxpUnz0Ee', name = 'changeme' },
	-- [`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://giphy.com/embed/RK9haRikbTklYdamuJ', name = 'changeme' },
	-- [`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://i.giphy.com/media/J21RStzm6XLnQBGbLm/giphy-downsized-large.gif', name = 'changeme' },
	-- [`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://giphy.com/embed/2SYpZ92iLQsF6QZl5u', name = 'changeme' },
	-- [`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://giphy.com/embed/3bc8pP1rVdfgN1uoMV', name = 'changeme' },
	-- [`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://images.squarespace-cdn.com/content/v1/593ef81437c58155800f5e8b/1531931262084-1MZAHIIPG4U6Y17I3VIP/Fiit_GIF_09_500.gif?format=500w', name = 'changeme' },
	-- [`changeme`] = { active = false, dict = 'findthetexturedictionary', gif = 'https://giphy.com/embed/J2gw2mRcvjPyAz7kGj', name = 'changeme' }
}

function loadTxd(model, liveryDict, gif) 
    local txd = CreateRuntimeTxd('duiTxd')
    local duiObj = CreateDui(gif, 480, 480)
    _G.duiObj = duiObj
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTex', dui)
    AddReplaceTexture(model, liveryDict, 'duiTxd', 'duiTex')
end

function MainThread()
	for k, v in pairs(animatedCars) do
		if k then
			totalVipCars = totalVipCars + 1
		end
	end
	CreateThread(function()
		while loaded == false do
			Wait(2500)
			for veh in EnumerateVehicles() do
				local dist = #(GetEntityCoords(veh) - GetEntityCoords(PlayerPedId()))
				if dist <= 150 then
					local model = GetEntityModel(veh)
					if animatedCars[model] then
						local yeet = animatedCars[model]
						if not yeet.active then
							loadTxd(yeet.name, yeet.dict, yeet.gif)
							animatedCars[model].active = true
						end
					end
				end
			end
		end
	end)
	CreateThread(function()
		while loaded == false do
			Wait(10000)
			local total = 0
			for k, v in pairs(animatedCars) do
				if v.active then
					total = total + 1
				end
			end
			if total == totalVipCars then
				loaded = true
			end
			total = 0
		end
	end)
end

AddEventHandler('onClientResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		MainThread()
	end
end)


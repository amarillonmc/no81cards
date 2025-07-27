--皇庭学院衍生物
in_count = {
	[0] = 0,
	[1] = 0,
	["0"] = nil,
	["1"] = nil,
	["card"] = nil,
	["update"] = function()
		for x = 0,1 do
			if aux.GetValueType(in_count[tostring(x)]) == "Effect" then
				in_count[tostring(x)]:Reset()
				in_count[tostring(x)] = nil
			end
			in_count[tostring(x)]=Effect.CreateEffect(in_count.card)
			in_count[tostring(x)]:SetDescription(aux.Stringid(21196000,in_count[x]))
			in_count[tostring(x)]:SetType(EFFECT_TYPE_FIELD)
			in_count[tostring(x)]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			in_count[tostring(x)]:SetTargetRange(1,0)
			in_count[tostring(x)]:SetValue(1)
			Duel.RegisterEffect(in_count[tostring(x)],x)
		end
	end,
	["add"] = function(player,count)
		in_count[player] = in_count[player] + count
		if in_count[player] > 8 then in_count[player] = 8 end
		if in_count[player] < 0 then in_count[player] = 0 end
		in_count.update()
	end,		
	["reset"] = function(player)
		in_count[player] = 0
		in_count.update()
	end,	
}
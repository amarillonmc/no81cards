--宝石结晶龙
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	Scl.AddSynchroProcedure(c, aux.Tuner(nil), nil, nil, aux.NonTuner(nil), 1)
	local e1 = Scl.CreateSingleTriggerOptionalEffect(c, )
end

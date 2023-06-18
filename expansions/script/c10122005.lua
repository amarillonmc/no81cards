--梦吟
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl.AddTokenList(c, 10122011)
	local e1 = Scl.CreateActivateEffect(c, "FreeChain", "SpecialSummonToken", { 1, id }, "SpecialSummonToken", nil, nil, nil, Scl_Utoland.Token_Target(1, 1, nil, true), s.act)
	local e2 = Scl.CreateFieldTriggerOptionalEffect(c, "BePlacedOnField", "Return2Hand", {1, id + 100}, "Return2Hand", "Delay", "GY", s.thcon, nil, { "~Target", "Return2Hand", Card.IsAbleToHand }, s.thop)
end
function s.act(e,tp)
	local maxct = Duel.GetFieldCard(tp,LOCATION_SZONE,5) and 2 or 1
	Scl_Utoland.SpecialSummonToken(e:GetHandler(), tp, 1, maxct)
end
function s.thcon(e,tp,eg)
	return eg:IsExists(s.thcfilter,1,nil,tp)
end
function s.thcfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsCode(10122011)
end
function s.thop(e,tp)
	local _, c = Scl.GetActivateCard()
	if c then
		Scl.Send2Hand(c, nil, REASON_EFFECT, true)
	end
end
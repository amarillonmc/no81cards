--梦坠
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
 
	local e1 = Scl.CreateActivateEffect(c, "FreeChain", "Destroy", {1, id}, "Destroy", "Target", nil, nil, { "Target", "Destroy", {aux.TRUE, s.gcheck}, "OnField", "OnField", 1, 3 }, s.act)
	local e2 = Scl.CreateFieldTriggerOptionalEffect(c, "BePlacedOnField", "Return2Hand", {1, id + 100}, "Return2Hand", "Delay", "GY", s.thcon, nil, { "~Target", "Return2Hand", Card.IsAbleToHand }, s.thop)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and Scl.IsOriginalType(c,0,TYPE_MONSTER) and c:IsSetCard(0xc333)
end
function s.gcheck(g,e,tp)
	return g:IsExists(s.cfilter,1,nil,tp)
end
function s.act(e,tp)
	local g= Scl.GetTargetsReleate2Chain()
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
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
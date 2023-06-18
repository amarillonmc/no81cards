--量子驱动 η侦查机
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl_Quantadrive.FilpEffect(c, s, id, "Banish", "Banish", { "~Target", "Banish", Card.IsAbleToRemove, 0, "Hand" }, s.rmop)
	local e2 = Scl_Quantadrive.NormalSummonEffect(c, s, id, "BeSet")
	Scl_Quantadrive.CreateNerveContact(s, e1, e2)
end
function s.rmop(e,tp)
	local g = Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g == 0 then return end
	Duel.ConfirmCards(tp,g)
	local rg = g:Filter(Card.IsAbleToRemove,nil)
	if #rg == 0 then return end
	local rg2 = rg:RandomSelect(tp,1)
	Scl.Banish(rg2,POS_FACEUP,REASON_EFFECT + REASON_TEMPORARY,1,2,PHASE_END)
	Duel.ShuffleHand(1-tp)
end
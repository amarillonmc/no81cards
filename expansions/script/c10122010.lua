--初醒
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c,"FreeChain","Destroy",nil,"Destroy,Draw,BanishFacedown", nil, nil, nil, { { "~Target", "Destroy", s.dfilter, "OnField",0, true, true, c }, { "PlayerTarget", "Draw", scl.black_hole_count } }, s.act)
end
function s.act(e,tp)
	local g = Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	if #g == 0 then return end
	local ct = Duel.Destroy(g,REASON_EFFECT)
	if ct == 0 then return end
	local rg = Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	if Duel.Draw(tp,ct,REASON_EFFECT) > 0 and ct >= 8 and #rg > 0 and Scl.SelectYesNo(tp, "BanishFacedown") then
		Duel.BreakEffect()
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end
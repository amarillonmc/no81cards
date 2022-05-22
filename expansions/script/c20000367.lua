--奉神天使 基础
local s,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function s.initial_effect(c)
	local e = {fu_god.Counter(c,CATEGORY_TODECK,EVENT_TO_HAND,EFFECT_FLAG_DELAY,s.con,s.tg,s.op)}
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(s.tgf,nil,tp)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		fu_god.Reg(e,m,tp)
end
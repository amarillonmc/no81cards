--奉神天使 基础
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e = {fu_god.Counter(c,CATEGORY_TODECK,EVENT_TO_HAND,EFFECT_FLAG_DELAY,cm.con,cm.tg,cm.op)}
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
		local g = eg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
		if #g>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		fu_god.Reg(e,m,tp)
end
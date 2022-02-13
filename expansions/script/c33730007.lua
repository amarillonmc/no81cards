-- 键★等 －拼死安利 / K.E.Y Etc. Spinta Roboante
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x460)
		return Duel.IsPlayerCanDraw(tp,2) and g:GetClassCount(Card.GetCode)>=7 
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,7,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.check(c,loc,p)
	return c:IsLocation(loc) and c:IsControler(p)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsSetCard),tp,LOCATION_GRAVE,0,nil,0x460)
	if g:GetClassCount(Card.GetCode)<7 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,7,7)
	aux.GCheckAdditional=nil
	Duel.SendtoDeck(sg,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	for p=0,1 do
		if og:Filter(Card.IsControler,nil,p):IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(p)
		end
	end
	local ct=og:FilterCount(s.check,nil,LOCATION_DECK+LOCATION_EXTRA,1-tp)
	if ct>=7 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
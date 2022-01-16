--清者自清
local m=13255402
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and re:GetActivateLocation()~=re:GetHandler():GetLocation()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil,re:GetHandler():GetCode())
	if chk==0 then return true end
	if not re:GetHandler():IsLocation(LOCATION_DECK) and re:GetHandler():IsAbleToDeck() then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	--[[
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil,eg:GetFirst():GetCode())
	local gms=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	g:Sub(mgs)
	]]
	
	local tc=eg:GetFirst()
	if not re:GetHandler():IsLocation(LOCATION_DECK) then
		if Duel.SendtoDeck(eg,nil,0,REASON_EFFECT)==0 then return end
	end
	Duel.ShuffleDeck(1-tp)
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(1-tp,1)
	local rg=Group.CreateGroup()
	local tpe=tc:GetType()
	if bit.band(tpe,TYPE_TOKEN)==0 then
		local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil,tc:GetCode())
		rg:Merge(g1)
	end
	if rg:GetCount()>0 then
		Duel.BreakEffect()
		local dp=1
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 then
			if rg:FilterCount(Card.IsControler,nil,tp)==0 then
				dp=dp+1
			end
			if rg:FilterCount(Card.IsControler,nil,1-tp)>=3 then
				dp=dp+1
			end
		end
		Duel.Draw(tp,dp,REASON_EFFECT)
	end
end

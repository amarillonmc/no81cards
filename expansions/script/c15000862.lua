local m=15000862
local cm=_G["c"..m]
cm.name="记载于修珀川的降临"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000850)
	aux.AddRitualProcGreater2(c,cm.filter,LOCATION_HAND,cm.mfilter)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15000862)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x9f3c)
end
function cm.mfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.tdfilter(c)
	return c:IsSetCard(0x9f3c) and ((c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)))
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsType,1,nil,TYPE_EQUIP) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SendtoDeck(g,nil,1,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			if g:GetFirst():IsCode(15000850) and Duel.IsPlayerCanDraw(tp,1) then
				local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
				Duel.Draw(p,d,REASON_EFFECT)
			end
		end
	end
end
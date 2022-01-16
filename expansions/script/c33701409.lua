--动物朋友编年史
local m=33701409
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	return g:GetClassCount(Card.GetCode,nil)==g:GetCount()
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:IsFaceup() and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,g:GetCount(),nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,g:GetCount())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if og:GetCount()>0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CHANGE_DAMAGE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(0)
				e1:SetReset(RESET_PHASE+PHASE_END,1)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
				e2:SetReset(RESET_PHASE+PHASE_END,1)
				Duel.RegisterEffect(e2,tp)
			end
			if og:GetCount()>6 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1:SetCode(EVENT_PHASE+PHASE_DRAW)
				e1:SetCountLimit(1)
				e1:SetReset(RESET_PHASE+PHASE_END,3)
				e1:SetCondition(cm.condition1)
				e1:SetOperation(cm.operation)
				Duel.RegisterEffect(e1,tp)
			end	 
			if og:GetCount()>14 then
				Duel.Recover(tp,1000*og:GetCount(),REASON_EFFECT)
			end
		end
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)
	if ct>=7 then e:Reset() return end
	local ct=7-ct
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.BreakEffect()
	local rg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	Duel.ConfirmCards(1-tp,rg)
	if rg:GetClassCount(Card.GetCode)~=#g then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
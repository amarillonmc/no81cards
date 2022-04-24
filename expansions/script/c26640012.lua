--下午茶时间
local m=26640012
local cm=_G["c"..m]
function c26640012.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,26640012)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26640112)
    e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,26640212)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
end
function cm.dfilter(c)
	return  c:IsAbleToGrave() 
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		if Duel.GetFirstMatchingCard(cm.dfilter,tp,LOCATION_REMOVED,0,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil,tp)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		end
	end
end
-----发动效果
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceup() and c:IsSetCard(0xe51)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.thfilter1(c)
	return c:IsSetCard(0xe51) and c:IsType(TYPE_MONSTER)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,3,nil)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local hg1=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_GRAVE,0,nil)
		if ct>=1 then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		
		if ct>=2 and hg1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ag=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
			local tc=ag:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		
		if ct>=3  then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			end
		end
end
----2效果
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe51) and not  c:IsCode(26640012)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		if Duel.IsPlayerCanDiscardDeck(tp,1) then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,1,REASON_EFFECT)
		end
	end
end

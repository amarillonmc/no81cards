local m=82228571
local cm=_G["c"..m]
function cm.initial_effect(c) 
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e1:SetCondition(cm.con)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--draw  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DRAW)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.drcon)  
	e2:SetTarget(cm.drtg)  
	e2:SetOperation(cm.drop)  
	c:RegisterEffect(e2)  
end  
function cm.cfilter(c)  
	return c:IsCode(82228562)  
end  
function cm.con(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)  
end 
function cm.filter(c)  
	return c:IsAbleToRemove()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)  
	end  
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
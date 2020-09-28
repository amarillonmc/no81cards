local m=82228621
local cm=_G["c"..m]
cm.name="孑影之故国"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--change pos 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_POSITION)  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE) 
	e2:SetTarget(cm.target)  
	e2:SetOperation(cm.operation)  
	c:RegisterEffect(e2)  
end
function cm.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3299) and c:IsAbleToHand()  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end  
function cm.tgfilter(c)  
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE) 
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)>0 then 
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		e1:SetCode(EFFECT_UPDATE_DEFENSE)  
		e1:SetValue(-1000)  
		tc:RegisterEffect(e1) 
	end
end
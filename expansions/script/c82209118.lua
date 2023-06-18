--高估的传说
local m=82209118
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.filter(c)  
	return c:IsAttackAbove(3000) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,g)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD)  
		e1:SetCode(EFFECT_SET_BASE_ATTACK)  
		e1:SetTargetRange(LOCATION_MZONE,0)  
		e1:SetTarget(cm.atktg)  
		e1:SetLabel(g:GetFirst():GetOriginalCodeRule())
		e1:SetValue(0)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e1,tp) 
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_FIELD)  
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
		e2:SetTargetRange(1,0)  
		e2:SetValue(cm.aclimit)  
		e2:SetLabel(g:GetFirst():GetCode())  
		e2:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e2,tp) 
	end  
end
function cm.atktg(e,c)  
	return c:GetOriginalCodeRule()==e:GetLabel()
end  
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)  
end  
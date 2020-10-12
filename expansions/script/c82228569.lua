local m=82228569
local cm=_G["c"..m]
function cm.initial_effect(c) 
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
	--change cost 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(82228569)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,0)  
	c:RegisterEffect(e2) 
	--destroy
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetCountLimit(1)  
	e3:SetCode(EVENT_PHASE+PHASE_END)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(cm.descon)  
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return tp==Duel.GetTurnPlayer()  
end  
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x297)
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
	if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	else
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil) 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) 
	end 
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
		if g:GetCount()>0 then   
			Duel.Destroy(g,REASON_EFFECT)  
		end	
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then  
			Duel.HintSelection(g)  
			Duel.Destroy(g,REASON_EFFECT)  
		end   
	end  
end  
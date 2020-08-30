local m=82204115
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)	
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_RELEASE)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.setcon)  
	e2:SetTarget(cm.settg)  
	e2:SetOperation(cm.setop)  
	c:RegisterEffect(e2) 
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0xbb) 
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)  
		and Duel.IsPlayerCanDraw(1-tp,1) end  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,g)  
	Duel.ChangeChainOperation(ev,cm.repop)  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoGrave(tc,REASON_RETURN+REASON_EFFECT)
end  
function cm.setfilter(c,tp)  
	return c:IsPreviousLocation(LOCATION_MZONE) 
end  
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.setfilter,1,nil,tp)  
end  
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsSSetable() end  
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)  
end  
function cm.setop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsSSetable() then  
		Duel.SSet(tp,c)  
		Duel.ConfirmCards(1-tp,c)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e1:SetValue(LOCATION_REMOVED)  
		c:RegisterEffect(e1)  
	end  
end  
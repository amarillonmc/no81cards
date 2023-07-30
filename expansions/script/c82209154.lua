--源数使者
local m=82209154
local cm=c82209154
function cm.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.copycon)
	e2:SetCost(cm.copycost)
	e2:SetTarget(cm.copytg)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and c:IsAbleToGraveAsCost() end  
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)  
	Duel.SendtoGrave(c,REASON_COST)
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 then  
		Duel.Destroy(g,REASON_EFFECT)  
	end  
end  
function cm.copycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,41418852)
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)  
	return true 
end  
function cm.copyfilter(c)  
	return c:IsCode(41850466) and c:IsAbleToGraveAsCost()  
		and c:CheckActivateEffect(false,true,false)~=nil  
end  
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then  
		if e:GetLabel()==0 then return false end  
		e:SetLabel(0)  
		return Duel.GetFlagEffect(tp,m)==0 and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)  
	end  
	e:SetLabel(0) 
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) 
	Duel.Remove(c,POS_FACEUP,REASON_COST) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)  
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)  
	Duel.SendtoGrave(g,REASON_COST)  
	e:SetProperty(te:GetProperty())  
	local tg=te:GetTarget()  
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
	te:SetLabelObject(e:GetLabelObject())  
	e:SetLabelObject(te)  
	Duel.ClearOperationInfo(0)  
end  
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)  
	local te=e:GetLabelObject()  
	if not te then return end  
	e:SetLabelObject(te:GetLabelObject())  
	local op=te:GetOperation()  
	if op then op(e,tp,eg,ep,ev,re,r,rp) end  
end  
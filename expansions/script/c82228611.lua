local m=82228611
local cm=_G["c"..m]
cm.name="荒兽 驳"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--destroy 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EFFECT_SELF_DESTROY)  
	e1:SetCondition(cm.descon)  
	c:RegisterEffect(e1) 
	--immune spell  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_IMMUNE_EFFECT)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(cm.efilter)  
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))	 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_PHASE+PHASE_END)  
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1) 
	e3:SetCost(cm.mtcost)
	e3:SetTarget(cm.mttg)  
	e3:SetOperation(cm.mtop) 
	c:RegisterEffect(e3) 
end
function cm.descon(e)  
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x2299)  
end  
function cm.efilter(e,te)  
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()  
end  
function cm.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.mtfilter(c)  
	return c:IsSetCard(0x2299) and c:IsType(TYPE_MONSTER)
end  
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)  
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_DECK,0,1,nil) end  
end  
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.Overlay(c,g)  
	end  
end  

local m=15000242
local cm=_G["c"..m]
cm.name="猎杀：永寂之国"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(cm.con) 
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
end
function cm.tgfilter(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0xaf37)
end
function cm.con(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tp=e:GetHandler():GetControler() 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.SetChainLimit(cm.chainlm)  
	end  
end
function cm.chainlm(e,rp,tp)  
	return not (e:GetHandler():IsType(TYPE_MONSTER) or e:GetHandler():IsType(TYPE_TRAP))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.NegateRelatedChain(g:GetFirst(),RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)  
		g:GetFirst():RegisterEffect(e1)  
		local e2=Effect.CreateEffect(e:GetHandler())  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)  
		g:GetFirst():RegisterEffect(e2)
	end
end
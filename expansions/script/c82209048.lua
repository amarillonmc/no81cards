local m=82209048
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--atk down  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(0,LOCATION_MZONE)  
	e2:SetValue(cm.atkval)  
	c:RegisterEffect(e2)  
	--destroy  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.descon)  
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3) 
end
cm.SetCard_01_Kieju=true
function cm.isKieju(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_Kieju
end
function cm.atkfilter(c)
	return cm.isKieju(c:GetCode()) and c:IsFaceup()
end
function cm.atkval(e)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_PZONE,0,nil)*-300  
end  
function cm.desfilter(c)
	return c:IsAttackBelow(1000) and c:IsFaceup()
end
function cm.desfilter0(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and cm.isKieju(c:GetCode())
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	local ct=Duel.GetMatchingGroup(cm.desfilter0,tp,LOCATION_SZONE,0,nil):GetCount() 
	if g:GetCount()==0 or ct==0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local sg=g:Select(tp,1,ct,nil)  
	Duel.HintSelection(sg)  
	Duel.Destroy(sg,REASON_EFFECT)  
end  
--像素战士
local m=82209083
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.splimit)  
	c:RegisterEffect(e0)   
	--register
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(cm.reg)
	Duel.RegisterEffect(e1,tp)
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCode(EVENT_FREE_CHAIN)   
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
	--remove  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)  
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(0xff,0xff) 
	e3:SetValue(LOCATION_REMOVED)  
	e3:SetTarget(cm.rmtg)  
	c:RegisterEffect(e3)  
end
function cm.splimit(e,se,sp,st)  
	return se:GetHandler()==e:GetHandler()
end  
function cm.reg(e,tp,eg,ep,ev,re,r,rp)  
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function cm.spfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,0,LOCATION_GRAVE,10,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then  
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.rmtg(e,c)  
	return c:GetOwner()~=e:GetHandlerPlayer()  
end  
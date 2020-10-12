function c82228001.initial_effect(c)  
	--destroy 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228001,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,82228001) 
	e1:SetCondition(c82228001.descon)  
	e1:SetTarget(c82228001.destg)  
	e1:SetOperation(c82228001.desop)  
	c:RegisterEffect(e1)  
	--pierce
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e2)
end  

function c82228001.descon(e,tp,eg,ep,ev,re,r,rp)  
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x290)  
end  

function c82228001.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)  
end  

function c82228001.desop(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())  
	Duel.Destroy(sg,REASON_EFFECT)  
end  
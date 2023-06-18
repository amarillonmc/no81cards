--自然控制机器-深绿
function c98900122.initial_effect(c)
			c:EnableReviveLimit()
		--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)  
  --sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98900122,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c98900122.spcon)
	e2:SetTarget(c98900122.sptg)
	e2:SetOperation(c98900122.spop)   
	c:RegisterEffect(e2)  
  --todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98900122,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c98900122.target)
	e1:SetOperation(c98900122.operation)
	c:RegisterEffect(e1)
end
function c98900122.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98900122.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,10,nil)
end
function c98900122.cfilter1(c)
	return c:IsFacedown() or c:IsFaceup()
end
function c98900122.chainlm(e,rp,tp)
	return not e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c98900122.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(c98900122.chainlm)   
end
function c98900122.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function c98900122.filter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToGrave()
end
function c98900122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98900122.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c98900122.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(c98900122.chainlm)
end
function c98900122.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c98900122.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoGrave(sg,nil,REASON_EFFECT)   
end

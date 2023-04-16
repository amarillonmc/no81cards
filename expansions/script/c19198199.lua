--星际仙踪-流浪者
function c19198199.initial_effect(c)
	c:SetSPSummonOnce(19198199) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198199,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,19198199)
	e1:SetCost(c19198199.spcost)
	e1:SetTarget(c19198199.sptg)
	e1:SetOperation(c19198199.spop)
	c:RegisterEffect(e1) 
	--Destroy  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(19198199,2))
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCost(c19198199.descost) 
	e2:SetTarget(c19198199.destg) 
	e2:SetOperation(c19198199.desop) 
	c:RegisterEffect(e2) 
end
function c19198199.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c19198199.spfilter(c,e,tp)
	return c:IsSetCard(0xd2) and c:IsLevelAbove(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19198199.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c19198199.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c19198199.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19198199.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19198199.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c19198199.desfil(c) 
	return c:IsSetCard(0xd2) and not c:IsCode(19198199)
end 
function c19198199.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198199.desfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK) 
end 
function c19198199.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198199.desfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT)	
	end  
end 













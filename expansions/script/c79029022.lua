--格拉斯哥帮·先锋干员-推进之王
function c79029022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c79029022.ovfilter,aux.Stringid(79029022,1))
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029022,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c79029022.stgtarget)
	e1:SetCost(c79029022.stgcost)
	e1:SetOperation(c79029022.stgoperation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029022,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029022.spcon)
	e2:SetTarget(c79029022.sptg)
	e2:SetOperation(c79029022.spop)
	c:RegisterEffect(e2)
end
function c79029022.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsRank(6)
end
function c79029022.dfil(c,e)
	return c:IsFaceup() and c:IsAttackBelow(e:GetHandler():GetAttack())
end
function c79029022.stgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029022.stgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c79029022.dfil,tp,0,LOCATION_MZONE,nil,e)>=1 end
	local g=Duel.GetMatchingGroup(c79029022.dfil,tp,0,LOCATION_MZONE,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029022.stgoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029022.dfil,tp,0,LOCATION_MZONE,nil,e)
	local x=Duel.GetMatchingGroupCount(c79029022.dfil,tp,0,LOCATION_MZONE,nil,e)
	local x1=Duel.Destroy(g,REASON_EFFECT)
	e:GetHandler():AddCounter(0x1099,x1)
end
function c79029022.spfilter(c,e,tp)
	local a=e:GetHandler():GetCounter(0x1099)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<=a and c:IsLevelAbove(1)
end
function c79029022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReleasable()
end
function c79029022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029022.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tg=Duel.SelectMatchingCard(tp,c79029022.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if tg then
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end
end


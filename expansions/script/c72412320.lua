--共誓黎明
function c72412320.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72412320)
	e1:SetCondition(c72412320.spcon)
	e1:SetTarget(c72412320.sptg)
	e1:SetOperation(c72412320.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,72412320)
	e2:SetCost(c72412320.fusioncost)
	e2:SetTarget(c72412320.fusiontg)
	e2:SetOperation(c72412320.fusionop)
	c:RegisterEffect(e2)
end
function c72412320.cfilter(c)
	return c:IsFaceup() and c:IsCode(68468459,60303688)
end
function c72412320.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72412320.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c72412320.tfilter(c,e,tp)
	return c:IsCode(68468459,60303688) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c72412320.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c72412320.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function c72412320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72412320.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72412320.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c72412320.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c72412320.filter1(c,e,tp)
	return c:IsCode(84339249) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c72412320.filter2(c,e,tp)
	return c:IsCode(25451383) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c72412320.fcfilter(c,e,tp)
	local b1=c:IsCode(60303688) and Duel.IsExistingMatchingCard(c72412320.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) and c:IsAbleToRemoveAsCost()
	local b2=c:IsCode(68468459) and Duel.IsExistingMatchingCard(c72412320.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) and c:IsAbleToRemoveAsCost()
	return b1 or b2
end
function c72412320.fusioncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroupCount(c72412320.fcfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and gc>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c72412320.fcfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		e:SetLabel(g:GetFirst():GetCode())
		g:AddCard(e:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c72412320.fusiontg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72412320.fusionop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g
	if e:GetLabel()==60303688 then
		g=Duel.SelectMatchingCard(tp,c72412320.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	elseif e:GetLabel()==68468459 then
		g=Duel.SelectMatchingCard(tp,c72412320.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
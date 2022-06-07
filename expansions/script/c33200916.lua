--寒霜灵兽 急冻鸟
function c33200916.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200916)
	e1:SetCost(c33200916.spcost)
	e1:SetTarget(c33200916.sptg)
	e1:SetOperation(c33200916.spop)
	c:RegisterEffect(e1)
	--spsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200916,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,33210916)
	e2:SetCost(c33200916.spcost1)
	e2:SetTarget(c33200916.sptg1)
	e2:SetOperation(c33200916.spop1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200916,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)   
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33220916)
	e3:SetCondition(c33200916.tpcon)
	e3:SetTarget(c33200916.tptg)
	e3:SetOperation(c33200916.tpop)
	c:RegisterEffect(e3)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200916,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c33200916.rectg)
	e4:SetOperation(c33200916.recop)
	c:RegisterEffect(e4) 
end

--e1
function c33200916.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200916.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200916.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200916.tgfilter(c)
	return (c:IsSetCard(0x332a) or c:IsSetCard(0x881)) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c33200916.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200916.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c33200916.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33200916.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200916.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e4
function c33200916.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_MZONE)
end
function c33200916.rmfilter(c)
	return c:GetCounter(0x132a)>0 and c:IsAbleToRemove()
end
function c33200916.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200916.rmfilter,tp,0,LOCATION_ONFIELD,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c33200916.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c33200916.rmfilter,tp,0,LOCATION_ONFIELD,1,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c33200916.rmfilter,tp,0,LOCATION_ONFIELD,1,1,c)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--e4
function c33200916.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x132a,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x132a)
end
function c33200916.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(Card.IsCanAddCounter,nil,0x132a,1)
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x132a,1) then
			tc:AddCounter(0x132a,1)
		end
	end
end
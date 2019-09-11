--亚马逊骑士·Sigma
function c9980919.initial_effect(c)
   --spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980919,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9980919)
	e2:SetTarget(c9980919.rmtg)
	e2:SetOperation(c9980919.rmop)
	c:RegisterEffect(e2)
	--special summon 2
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9980919,1))
	e8:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,99809190)
	e8:SetCondition(c9980919.spcon2)
	e8:SetTarget(c9980919.sptg2)
	e8:SetOperation(c9980919.spop2)
	c:RegisterEffect(e8)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980919.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980919.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980919,2))
end
function c9980919.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c9980919.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9980919.rmfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(c9980919.rmfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c9980919.rmfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c9980919.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9980919.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980919.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980919.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsStatus(STATUS_PROC_COMPLETE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
end
function c9980919.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)==0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
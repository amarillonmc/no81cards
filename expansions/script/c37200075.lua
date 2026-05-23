--限制·无限制者
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),aux.FilterBoolFunction(Card.IsFusionSetCard,0x3b70),true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tgtg1)
	e1:SetOperation(s.tgop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1192)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.tgtg2)
	e2:SetOperation(s.tgop2)
	c:RegisterEffect(e2)
end
function s.tgfilter1(c,tp)
	return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
end
function s.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsOnField() and s.tgfilter1(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,37200080,0x3b70,TYPES_TOKEN_MONSTER,0,0,3,RACE_SPELLCASTER,ATTRIBUTE_WATER)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,s.tgfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.Release(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local token=Duel.CreateToken(tp,37200080)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tgfilter2(c)
	return c:IsReleasableByEffect() and c:IsType(TYPE_TOKEN)
end
function s.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function s.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g1>0 and Duel.Release(g1,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g2>0 then
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		end
	end
end

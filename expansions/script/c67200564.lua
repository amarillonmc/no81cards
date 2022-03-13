--巧壳将 噶尔姆斯
function c67200564.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(67200564)
	aux.AddLinkProcedure(c,c67200564.mfilter,1,1) 
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_MOVE)
	e3:SetCountLimit(1,67200564)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c67200564.ctcon1)
	e3:SetTarget(c67200564.cttg1)
	e3:SetOperation(c67200564.ctop1)
	c:RegisterEffect(e3)
end
function c67200564.mfilter(c)
	return c:IsLinkSetCard(0x676) and c:IsLinkType(TYPE_PENDULUM)
end
--
function c67200564.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x676) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c67200564.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200564.cfilter,1,e:GetHandler(),tp)
end
function c67200564.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x676)
end
function c67200564.spfilter(c,e,tp)
	return c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c67200564.cttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200564.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(c67200564.recfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,ct*300)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67200564.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c67200564.recfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(p,ct*300,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c67200564.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(67200564,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200564.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


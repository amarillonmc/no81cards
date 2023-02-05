--奴隶象
function c98920000.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c98920000.sptg1)
	e1:SetOperation(c98920000.spop1)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	  --damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c98920000.damop)
	c:RegisterEffect(e3)
--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)	
	e2:SetCountLimit(1,98930000+EFFECT_COUNT_CODE_DUEL)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920000.target)
	e2:SetOperation(c98920000.activate)
	c:RegisterEffect(e2)
end
function c98920000.spfilter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c98920000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920000.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98920000.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920000.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)local tc=g:GetFirst()
	if tc then
			Duel.SpecialSummon(tc,SUMMON_VALUE_GLADIATOR,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
	end
end
function c98920000.cfilter(c)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSetCard(0x19)
end
function c98920000.damop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c98920000.cfilter,nil,tp)>0 then
	  Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c98920000.filter1(c,e)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c98920000.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf,true)
end
function c98920000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(c98920000.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
		return Duel.IsExistingMatchingCard(c98920000.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_MZONE)
end
function c98920000.cffilter(c)
	return (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function c98920000.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98920000.filter1),tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c98920000.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		local cf=mat:Filter(c98920000.cffilter,nil)
		if cf:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cf)
		end
		Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end

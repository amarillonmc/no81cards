--星核猎手·萨姆
function c78380359.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x746),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--SetCode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c78380359.eqcon)
	e1:SetValue(0x746)
	c:RegisterEffect(e1)
	--attack 2
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot target
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--skip
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,78380359)
	e4:SetCondition(c78380359.skcon)
	e4:SetTarget(c78380359.sktg)
	e4:SetOperation(c78380359.skop)
	c:RegisterEffect(e4)
end
function c78380359.eqfilter(c)
	return c:IsFaceup() and c:IsCode(78301023)
end
function c78380359.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	return g and g:IsExists(c78380359.eqfilter,1,nil)
end
function c78380359.skcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()~=tp
end
function c78380359.spfilter(c,e,tp)
	return c:IsSetCard(0x746) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78380359.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eg=c:GetEquipGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c78380359.spfilter,1,nil,e,tp) and c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_MZONE)
end
function c78380359.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetEquipGroup():Filter(c78380359.spfilter,nil,e,tp)
	--SpecialSummon
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or #sg==0 then return end
	local sc=nil
	if #sg==1 then sc=sg:GetFirst() else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
	end
	--ReturnExtra
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(78380359,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetTarget(c78380359.sytg)
		e1:SetOperation(c78380359.syop)
		sc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.BreakEffect()
			if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN1 then
				Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			end
		end
	end
end
function c78380359.sytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c78380359.syop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
	local tc=tg:GetFirst()
	if tc then
		Duel.SynchroSummon(tp,tc,nil)
	end
end

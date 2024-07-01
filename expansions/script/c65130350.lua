--出涸岚玛娜
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	--deck spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.dspcon)
	e1:SetTarget(s.dsptg)
	e1:SetOperation(s.dspop)
	c:RegisterEffect(e1)
	--grave spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.gspcon)
	e2:SetTarget(s.gsptg)
	e2:SetOperation(s.gspop)
	c:RegisterEffect(e2)
end
function s.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(s.cfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAttack(878) and c:IsDefense(1157)
end
function s.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.dspfilter(c,e,tp)
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function s.gspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.gspfilter(c,e,tp)
	return c:IsAttack(878) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsControler(tp)
end
function s.gsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.gspfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.gspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.gspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.xfilter(c)
	return c:IsXyzSummonable(nil)
end
function s.sfilter(c)
	return c:IsSynchroSummonable(nil)
end
function s.lfilter(c)
	return c:IsLinkSummonable(nil)
end
function s.gspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		if og:GetCount()>0 then
			Duel.AdjustAll()
			local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
			local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
			local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(id,3)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(id,4)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(id,5)
				opval[off-1]=3
				off=off+1
			end
			ops[off]=aux.Stringid(id,6)
			opval[off-1]=4
			off=off+1
			local op=Duel.SelectOption(tp,table.unpack(ops)) 
			if opval[op]==1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SynchroSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.XyzSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.LinkSummon(tp,g:GetFirst(),nil)
			end
		end
	end
end
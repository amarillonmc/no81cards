--工匠之魔导书
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cffilter(c)
	return c:IsSetCard(0x106e) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_EFFECT,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_RACE)
		e2:SetValue(RACE_SPELLCASTER)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_ADD_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_LIGHT)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(2800)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(1)
		tc:RegisterEffect(e6,true)
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
			--Return to hand
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e7:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e7:SetValue(LOCATION_HAND)
			tc:RegisterEffect(e7,true)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e8:SetCode(EVENT_TO_HAND)
			e8:SetCondition(s.thcon)
			e8:SetOperation(s.thop)
			Duel.RegisterEffect(e8,tp)
			tc:RegisterFlagEffect(id,RESET_EVENT+0x1de0000,0,1,tc:GetRealFieldID())
			--copy effect
			local e9=Effect.CreateEffect(c)
			e9:SetDescription(aux.Stringid(id,1))
			e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e9:SetType(EFFECT_TYPE_QUICK_O)
			e9:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
			e9:SetCode(EVENT_FREE_CHAIN)
			e9:SetRange(LOCATION_MZONE)
			e9:SetCondition(s.cpcon)
			e9:SetCost(s.cpcost)
			e9:SetTarget(s.cptg)
			e9:SetOperation(s.cpop)
			e9:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e9,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.thfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thfilter,1,nil)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:Reset()
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.costfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckActivateEffect(false,true,false) end
	local c=e:GetHandler()
	local te,ceg,cev,cre,cr,crp=c:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	c:CreateEffectRelation(e)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not (te and te:GetHandler():IsRelateToEffect(e)) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

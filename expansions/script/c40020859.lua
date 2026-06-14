--皇兽·Z·中狮子
local s,id=GetID()
s.named_with_EmperorBeast=1
s.ZEUS_CODE=40020683

function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,40020683)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.spcost2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+2)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end

function s.check_zeus(tp)
	local ex = Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(s.ZEUS_CODE) end, tp, LOCATION_EXTRA, 0, 1, nil)
	local pz0 = Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
	local pz1 = Duel.GetFieldCard(tp, LOCATION_PZONE, 1)
	local pz = ((pz0 and pz0:IsCode(s.ZEUS_CODE)) or (pz1 and pz1:IsCode(s.ZEUS_CODE)))
	return ex or pz
end

function s.costfilter(c)
	return c:IsCode(s.ZEUS_CODE) and c:IsReleasable()
end

function s.repfilter(c)
	if not c:IsCode(s.ZEUS_CODE) then return false end
	if not c:IsAbleToGraveAsCost() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK then return true end
	if loc == LOCATION_EXTRA then return c:IsFaceup() end
	return false
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_PZONE, 0, 1, nil)
	local b2 = Duel.IsPlayerAffectedByEffect(tp, s.ZEUS_CODE)
		and Duel.GetFlagEffect(tp, s.ZEUS_CODE) == 0
		and Duel.IsExistingMatchingCard(s.repfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, nil)
	if chk == 0 then
		return b1 or b2
	end
	if b2 and (not b1 or Duel.SelectYesNo(tp, aux.Stringid(s.ZEUS_CODE, 0))) then
		Duel.RegisterFlagEffect(tp, s.ZEUS_CODE, RESET_PHASE + PHASE_END, 0, 1)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local g = Duel.SelectMatchingCard(tp, s.repfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, 1, nil)
		Duel.SendtoGrave(g, REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
		local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
		Duel.Release(g, REASON_COST)
	end
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	c:SetMaterial(nil)
	if Duel.SpecialSummon(c, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP) > 0 then
		c:CompleteProcedure()
	end
end

function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.spfilter2(c,e,tp)
	return s.EmperorBeast(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if s.check_zeus(tp) and c:IsLocation(LOCATION_GRAVE) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
			
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				c:SetMaterial(nil)
				if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
					c:CompleteProcedure()
				end
			end
		end
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp, s.ZEUS_CODE) > 0 then
		Duel.ResetFlagEffect(tp, s.ZEUS_CODE)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCondition(s.flag_clear_con)
		e1:SetOperation(s.flag_clear_op)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		local e2=e1:Clone()
		e2:SetCode(EVENT_ADJUST)
		Duel.RegisterEffect(e2,tp)
	end
end

function s.flag_clear_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp, s.ZEUS_CODE) > 0
end

function s.flag_clear_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp, s.ZEUS_CODE)
	e:Reset()
end

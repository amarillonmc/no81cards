--炽焰之大天使
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,92512625)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg(EVENT_CHAINING))
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetTarget(s.sptg(EVENT_FREE_CHAIN))
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON)
	e3:SetTarget(s.sptg(EVENT_SUMMON))
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	e4:SetTarget(s.sptg(EVENT_FLIP_SUMMON))
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetTarget(s.sptg(EVENT_SPSUMMON))
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_TO_HAND)
	e6:SetTarget(s.sptg(EVENT_TO_HAND))
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetTarget(s.sptg(EVENT_ATTACK_ANNOUNCE))
	c:RegisterEffect(e7)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.costfilter(c,event)
	if not (bit.band(c:GetType(),TYPE_TRAP+TYPE_COUNTER)==TYPE_TRAP+TYPE_COUNTER and c:IsAbleToDeckAsCost()) then return false end
	local te=c:CheckActivateEffect(true,true,false)
	return te and te:GetCode()==event
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.sptg(event)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				if e:GetLabel()==0 then return false end
				e:SetLabel(0)
				return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
				and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,c,event)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,c,event)
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local te,ceg,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
			Duel.ClearTargetCard()
			tc:CreateEffectRelation(e)
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cev,cre,cr,crp,1) end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
			Duel.ClearOperationInfo(0)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function s.setfilter(c)
	return c:IsCode(92512625) and c:IsSSetable()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:IsSummonLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			--c:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
		local te=e:GetLabelObject()
		if not (te) then return end
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		Duel.Hint(HINT_CARD,0,te:GetHandler():GetCode())
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		if Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)~=0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
			local dc=g:GetFirst()
			if Duel.SSet(tp,dc,tp,false)==0 then return end
			if dc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(id,1))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetCondition(s.accon)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				dc:RegisterEffect(e1)
			end
			if dc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(id,1))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCondition(s.accon)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				dc:RegisterEffect(e1)
			end
		end
	end
end
function s.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevel(8)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,nil,e:GetHandler())
end
--美梦的 皮亚尼
function c75075600.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075600,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75075600)
	e1:SetCondition(c75075600.spcon)
	e1:SetTarget(c75075600.sptg)
	e1:SetOperation(c75075600.spop)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075600,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75075601)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75075600.postg)
	e2:SetOperation(c75075600.posop)
	c:RegisterEffect(e2)  
	----
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75075600,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCondition(c75075600.atkcon)
	e3:SetOperation(c75075600.atkop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	c:RegisterEffect(e4)
end
function c75075600.cfilter(c)
	return c:IsFacedown()
end
function c75075600.spfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function c75075600.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.IsExistingMatchingCard(c75075600.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c75075600.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c75075600.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75075600.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75075600.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_DEFENSE)
		end
	end
	Duel.SpecialSummonComplete()
end
--
function c75075600.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c75075600.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
--
function c75075600.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c75075600.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g>0 then
		Duel.Recover(tp,g*500,REASON_EFFECT)
	end
end


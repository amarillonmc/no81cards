--合辛的铁牙团长
function c17337702.initial_effect(c)
	--material redirect-hoshin
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_HAND)
	e0:SetCondition(c17337702.redcon)
	c:RegisterEffect(e0)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337702,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,17337702)
	e1:SetCondition(c17337702.spcon)
	e1:SetTarget(c17337702.sptg)
	e1:SetOperation(c17337702.spop)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17337702+1)
	e2:SetCondition(c17337702.icon)
	e2:SetCost(c17337702.atkcost)
	e2:SetTarget(c17337702.atktg)
	e2:SetOperation(c17337702.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c17337702.qcon)
	c:RegisterEffect(e3)
end
function c17337702.redcon(e)
	local c=e:GetHandler()
	return c:IsOnField() and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
function c17337702.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x3f51)
end
function c17337702.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17337702.chkfilter,1,nil,tp)
end
function c17337702.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17337702.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(17337702,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c17337702.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51))
end
function c17337702.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51)
end
function c17337702.costfilter(c)
	return c:IsSetCard(0x3f51) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c17337702.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c17337702.costfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337702.costfilter,tp,LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c17337702.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsAttackPos() end
end
function c17337702.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsAttackPos() and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
		local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,c):GetFirst()
		Duel.CalculateDamage(c,tc,true)
	end
end

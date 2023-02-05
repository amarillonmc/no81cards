--溯雪恋曲·冬马和纱
function c9911159.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9911159)
	e1:SetCondition(c9911159.condition1)
	e1:SetCost(c9911159.setcost)
	e1:SetTarget(c9911159.settg)
	e1:SetOperation(c9911159.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911159.condition2)
	c:RegisterEffect(e2)
	--Special Summon this card from your GY
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9911160)
	e3:SetCondition(c9911159.spcon)
	e3:SetCost(c9911159.spcost)
	e3:SetTarget(c9911159.sptg)
	e3:SetOperation(c9911159.spop)
	c:RegisterEffect(e3)
end
function c9911159.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911165)
end
function c9911159.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911165)
end
function c9911159.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9911159.setfilter(c)
	return c:IsSetCard(0x3958) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSSetable()
end
function c9911159.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9911159.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9911159.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9911159.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
function c9911159.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9911159.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.mzctcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local costg=g:SelectSubGroup(tp,aux.mzctcheck,false,2,2,tp)
	local label=0
	if costg:IsExists(Card.IsSetCard,2,nil,0x3958) then label=1 end
	e:SetLabel(label)
	Duel.SendtoGrave(costg,REASON_COST)
end
function c9911159.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	end
end
function c9911159.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
		if e:GetLabel()==1 and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(9911159,0)) then
			Duel.BreakEffect()
			Duel.NegateEffect(ev)
		end
	end
end

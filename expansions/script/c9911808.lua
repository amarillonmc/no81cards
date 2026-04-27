--不休烬灵
function c9911808.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911808)
	e1:SetCondition(c9911808.spcon)
	e1:SetTarget(c9911808.sptg)
	e1:SetOperation(c9911808.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9911808.reptg)
	e2:SetOperation(c9911808.repop)
	c:RegisterEffect(e2)
	--destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9911808.dedcon)
	e3:SetTarget(c9911808.dedtg)
	e3:SetOperation(c9911808.dedop)
	c:RegisterEffect(e3)
end
function c9911808.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c9911808.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911808.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911808,0xa957,TYPE_MONSTER+TYPE_EFFECT,800,1800,3,RACE_PYRO,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c9911808.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c9911808.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911808.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911808.thfilter(c)
	return c:IsSetCard(0xa957) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_PYRO) and c:IsAbleToHand()
end
function c9911808.desfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9911808.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,9911808)==0 and Duel.IsExistingMatchingCard(c9911808.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,9911809)==0 and Duel.IsExistingMatchingCard(c9911808.desfilter,tp,0,LOCATION_ONFIELD,1,nil,e)
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and (b1 or b2) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_CARD,0,9911808)
		local op=0
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911808,0),1},{b2,aux.Stringid(9911808,1),2})
		e:SetLabel(op)
		if op==1 then
			Duel.RegisterFlagEffect(tp,9911808,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c9911808.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif op==2 then
			Duel.RegisterFlagEffect(tp,9911809,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local g=Duel.SelectMatchingCard(tp,c9911808.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e)
			e:SetLabelObject(g:GetFirst())
			g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		end
		return true
	else return false end
end
function c9911808.repop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=2 then return end
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c9911808.dedcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9911808.dedtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,9911808)==0 and Duel.IsExistingMatchingCard(c9911808.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,9911809)==0
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911808,0),1},{b2,aux.Stringid(9911808,1),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.RegisterFlagEffect(tp,9911808,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.RegisterFlagEffect(tp,9911809,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c9911808.dedop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c9911808.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

--深渊书库的管理者 莉贝尔
function c11771460.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11771460)
	e1:SetCondition(c11771460.con1)
	e1:SetCost(c11771460.cost)
	e1:SetTarget(c11771460.tg)
	e1:SetOperation(c11771460.op)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCondition(c11771460.con2)
	c:RegisterEffect(e11)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(c11771460.distg)
	e2:SetOperation(c11771460.disop)
	c:RegisterEffect(e2)
end
function c11771460.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771460.spfilter(c,e,tp)
	return not c:IsCode(11771460) and c:IsType(TYPE_RITUAL)
		and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP)
end
function c11771460.disop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	local dc2=0
	local ck=0
	if not Duel.IsPlayerCanDraw(1-tp,1) or Duel.SelectYesNo(1-tp,aux.Stringid(11771460,0)) then
		dc2=Duel.TossDice(1-tp,1)
	else 
		ck=1
	end
	local p=-1
	if dc>dc2 then p=tp elseif dc<dc2 then p=1-tp end
	if p>=0 then
		local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,11771460)==0
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,p,0,0xc,1,nil)
			and Duel.GetFlagEffect(tp,11771460+1)==0
		local b3=Duel.GetLocationCount(p,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c11771460.spfilter,p,0x13,0,1,nil,e,p)
			and Duel.GetFlagEffect(tp,11771460+2)==0
		local op=aux.SelectFromOptions(p,{b1,aux.Stringid(11771460,1)},{b2,aux.Stringid(11771460,2)},{b3,aux.Stringid(11771460,3)})
		if op==1 then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
			end
			Duel.RegisterFlagEffect(tp,11771460,RESET_PHASE+PHASE_END,0,1)
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
			Duel.RegisterFlagEffect(tp,11771460+1,RESET_PHASE+PHASE_END,0,1)
		elseif op==3 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(c11771460.spfilter),tp,0x13,0,1,1,nil,e,p)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,p,p,false,true,POS_FACEUP)
				g:GetFirst():CompleteProcedure()
			end
			Duel.RegisterFlagEffect(tp,11771460+2,RESET_PHASE+PHASE_END,0,1)
		end
	end
	if ck==1 then
		Duel.Draw(1-tp,1,0x40)
	end
end
function c11771460.confilter(c)
	return c:IsFaceup() and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
function c11771460.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11771460.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11771460.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11771460.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11771460.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c11771460.thfilter(c)
	return c:IsCode(11771470) and c:IsAbleToHand()
end
function c11771460.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
	local b2=Duel.IsExistingMatchingCard(c11771460.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771460.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==6 then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			c:CompleteProcedure()
		end
	elseif dc>=2 or dc<=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11771460.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if g:GetFirst():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
			end
		end
	end
end
--兴灭之蒙昧灵 佛莱格瑞
function c9911114.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911114,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c9911114.otcon)
	e1:SetOperation(c9911114.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--to hand or grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c9911114.condition)
	e3:SetCost(c9911114.thcost)
	e3:SetTarget(c9911114.thtg)
	e3:SetOperation(c9911114.thop)
	c:RegisterEffect(e3)
	--tribute summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c9911114.condition)
	e4:SetCost(c9911114.sumcost)
	e4:SetTarget(c9911114.sumtg)
	e4:SetOperation(c9911114.sumop)
	c:RegisterEffect(e4)
end
function c9911114.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9911114.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c9911114.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c9911114.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c9911114.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9911114.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9911114.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c9911114.thfilter(c)
	return c:IsSetCard(0xa954) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911114.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911114.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9911114.disfilter(c)
	return aux.NegateAnyFilter(c) and c:IsAbleToRemove()
end
function c9911114.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9911114.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local res=false
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			res=true
		end
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			res=true
		end
	end
	local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsSetCard,nil,0xa954)
	local g2=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if res and g1 and g1:GetClassCount(Card.GetCode)>=3 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9911114,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c9911114.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c9911114.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9911114.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9911114.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9911114.sumfilter(c)
	return c:IsSetCard(0xa954) and c:IsSummonable(true,nil,1)
end
function c9911114.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911114.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9911114.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,400,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911114.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end

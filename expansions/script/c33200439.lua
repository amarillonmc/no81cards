--魔力联合 梧桐
function c33200439.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200439+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200439.spcon)
	e1:SetOperation(c33200439.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200439,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200440)
	e2:SetTarget(c33200439.negtg)
	e2:SetOperation(c33200439.negop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33200441)
	e3:SetTarget(c33200439.thtg)
	e3:SetOperation(c33200439.thop)
	c:RegisterEffect(e3) 
end

--e1
function c33200439.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c33200439.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and Duel.IsExistingMatchingCard(c33200439.spfilter,tp,0,LOCATION_GRAVE,2,nil)
end
function c33200439.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200439.spfilter,tp,0,LOCATION_GRAVE,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--e2
function c33200439.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c33200439.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33200439.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(c33200439.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,c33200439.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil)
		if g:GetCount()~=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200439,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			local tc=g:GetFirst()
			if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end

--e3
function c33200439.thfilter1(c)
	return c:IsSetCard(0x3329) and c:IsAbleToHand()
end
function c33200439.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c33200439.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200439.thfilter1,tp,LOCATION_DECK,0,1,nil) 
		or Duel.IsExistingMatchingCard(c33200439.thfilter2,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c33200439.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c33200439.thfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c33200439.thfilter2,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	g1:Merge(g2)
	if g1:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=g1:Select(tp,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoHand(g3,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
		end
	end
end
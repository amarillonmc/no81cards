--人造人-念力复制品
function c98920690.initial_effect(c)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetOperation(c98920690.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--cannnot activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920690,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_SEARCH)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c98920690.target)
	e4:SetOperation(c98920690.operation)
	c:RegisterEffect(e4)
end
function c98920690.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) and Duel.IsExistingMatchingCard(c98920690.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
end
function c98920690.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() then return end
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_TRAP) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	elseif not tc:IsType(TYPE_TRAP) and Duel.SendtoGrave(c,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c98920690.thfilter,tp,LOCATION_DECK,0,1,nil) then
	   	local g=Duel.SelectMatchingCard(tp,c98920690.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end  
	end
end
function c98920690.thfilter(c)
	return c:IsSetCard(0xbc) and not c:IsCode(98920690) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920690.cffilter(c)
	return c:IsFacedown()
end
function c98920690.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c98920690.cffilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if cg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,cg)
		Duel.ConfirmCards(1-tp,cg)
		local exg=Group.CreateGroup()
		local g1=Duel.GetOperatedGroup()
		local tc=g1:GetFirst()
		while tc do
			local code=tc:GetOriginalCodeRule()
			--disable
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetLabel(code)
			e1:SetCondition(c98920690.discon)
			e1:SetOperation(c98920690.disop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetLabel(code)
			e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e4:SetTarget(c98920690.distg)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e4)
			tc=g1:GetNext()
		end
	end
end
function c98920690.distg(e,c)
	local code=e:GetLabel()
	return c:IsType(TYPE_TRAP) and c:IsOriginalCodeRule(code)
end
function c98920690.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(code) and re:IsActiveType(TYPE_TRAP)
end
function c98920690.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
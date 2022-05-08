--紫罗兰永恒花园
function c60001179.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c60001179.spcon)
	e2:SetOperation(c60001179.kop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c60001179.aclimit)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)

	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(60001179,0))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c60001179.thcon)
	e7:SetTarget(c60001179.thtg)
	e7:SetOperation(c60001179.thop)
	c:RegisterEffect(e7)

	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(60001179,1))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,60001179)
	e8:SetTarget(c60001179.hstg)
	e8:SetOperation(c60001179.hsop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e9)

	if not c60001179.global_check then
		c60001179.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001179.setcon)
		e4:SetOperation(c60001179.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001179.setter(c)
	return c:IsOriginalSetCard(60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001179.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001179.setter,1,nil)
end
function c60001179.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(c60001179.setter,nil):GetFirst()
	while tc do
		tc:RegisterFlagEffect(60001168,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c60001179.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function c60001179.kter(c)
	return c:IsFaceup()
end
function c60001179.kop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(c60001179.kter,nil):GetFirst()
	while tc do
		tc:RegisterFlagEffect(60001179,RESET_CHAIN,0,1)
		tc=eg:GetNext()
	end
end
function c60001179.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetFlagEffect(60001179)>0
end
function c60001179.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(60001168)>0 and tc:IsLocation(LOCATION_SZONE) then
		e:SetLabel(1)
	end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.IsCodeListed(tc,60001179)
end
function c60001179.thter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,60001179) and c:IsAbleToHand()
end
function c60001179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001179.thter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c60001179.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c60001179.thter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=Duel.SelectMatchingCard(tp,c60001179.thter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if Duel.SendtoHand(g3,nil,REASON_EFFECT)>0 and #g2>0 and e:GetLabel()>0 and Duel.SelectYesNo(tp,aux.Stringid(60001179,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g4=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g4>0 then
				Duel.Destroy(g4,REASON_EFFECT)
			end
		end
	end
end
function c60001179.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c60001179.filter(c,sc)
	return c:IsFaceup() and c:IsCode(60001179) and not c:IsType(sc:GetType())
end
function c60001179.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60001179.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001179.filter2,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c60001179.filter,tp,LOCATION_ONFIELD,0,1,nil,c) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60001179,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c60001179.filter2,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
	end
end
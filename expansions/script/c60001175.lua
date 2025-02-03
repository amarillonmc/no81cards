--紫罗兰永恒不灭
function c60001175.initial_effect(c)
	aux.AddCodeList(c,60001179)
	aux.EnableChangeCode(c,60001179,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001175,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c60001175.damcon)
	e2:SetTarget(c60001175.damtg)
	e2:SetOperation(c60001175.damop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60001175,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,60001175)
	e3:SetTarget(c60001175.hstg)
	e3:SetOperation(c60001175.hsop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e4)

	if not c60001175.global_check then
		c60001175.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001175.setcon)
		e4:SetOperation(c60001175.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001175.setter(c)
	return c:IsOriginalSetCard(60001175) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001175.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001175.setter,1,nil)
end
function c60001175.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001175.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001175.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(60001168)>0 and (tc:IsLocation(LOCATION_SZONE) or tc:IsPreviousLocation(LOCATION_SZONE)) then
		e:SetLabel(1)
	end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.IsCodeListed(tc,60001179)
end
function c60001175.smlter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c60001175.tjter(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001175.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c60001175.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60001175.smlter,tp,LOCATION_DECK,0,nil)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 and #g>0 and e:GetLabel()>0 and Duel.SelectYesNo(tp,aux.Stringid(60001175,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c60001175.smlter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end
function c60001175.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c60001175.filter(c,sc)
	return c:IsFaceup() and c:IsCode(60001179) and c:GetOriginalCode()~=sc:GetOriginalCode()
end
function c60001175.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(60001179)
end
function c60001175.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001175.filter2,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c60001175.filter,tp,LOCATION_ONFIELD,0,1,nil,c) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60001175,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c60001175.filter2,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
	end
end
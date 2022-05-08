--薇尔莉特·伊芙加登
function c60001167.initial_effect(c)
	aux.AddCodeList(c,60001179)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)

	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(60001167,0))
	e8:SetCategory(CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c60001167.ckcon)
	e8:SetTarget(c60001167.cktg)
	e8:SetOperation(c60001167.ckop)
	c:RegisterEffect(e8)

	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(60001167,1))
	e9:SetCategory(CATEGORY_TOHAND)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetCountLimit(1,60001167)
	e9:SetTarget(c60001167.hstg)
	e9:SetOperation(c60001167.hsop)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e10)
end
function c60001167.ckcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.IsCodeListed(tc,60001179)
end
function c60001167.cktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60001167.ckop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c60001167.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c60001167.filter(c,sc)
	return c:IsFaceup() and c:IsCode(60001179) and not c:IsType(sc:GetType())
end
function c60001167.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60001167.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001167.filter2,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c60001167.filter,tp,LOCATION_ONFIELD,0,1,nil,c) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60001167,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c60001167.filter2,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
	end
end
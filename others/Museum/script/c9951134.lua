--妖妖梦·白玉楼庭院
function c9951134.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   --return to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951134,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9951134.target)
	e4:SetOperation(c9951134.operation)
	c:RegisterEffect(e4)
  --Avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9951134.filter2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
  --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9951134)
	e3:SetCondition(c9951134.thcon)
	e3:SetTarget(c9951134.thtg)
	e3:SetOperation(c9951134.thop)
	c:RegisterEffect(e3)
end
function c9951134.filter2(e,c)
	return c:IsSetCard(0x3bd2)
end
function c9951134.filter(c)
	return c:IsSetCard(0x3bd2) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHand()
end
function c9951134.smfilter(c)
	return c:IsSetCard(0x3bd2) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c9951134.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE) and chkc:IsControler(tp) and c9951134.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951134.filter,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9951134.filter,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951134.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local g=Duel.GetMatchingGroup(c9951134.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9951134,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=g:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,sg,true,nil)
		end
	end
end
function c9951134.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9951134.filter(c)
	return c:IsSetCard(0x3bd2) and c:IsAbleToHand()
end
function c9951134.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951134.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951134.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951134.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
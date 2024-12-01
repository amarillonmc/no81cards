--原石龙 翡翠玉龙
function c98920743.initial_effect(c)
	aux.AddCodeList(c,81418467)
	--code
	aux.EnableChangeCode(c,43096270,LOCATION_HAND+LOCATION_GRAVE)	
	--Normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e4)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920743,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920743)
	e2:SetTarget(c98920743.thtg)
	e2:SetOperation(c98920743.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy monster
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920743,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(c98920743.descon)
	e5:SetTarget(c98920743.destg1)
	e5:SetOperation(c98920743.desop1)
	c:RegisterEffect(e5)
end
function c98920743.thfilter(c)
	return c:IsSetCard(0x1b9) and c:IsAbleToHand()
end
function c98920743.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c98920743.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98920743.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920743.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.ConfirmCards(1-tp,sg)
		local tg=sg:RandomSelect(1-tp,1)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local tc2=(sg-tg):GetFirst()
		Duel.SendtoGrave(tc2,REASON_EFFECT)
	end
end
function c98920743.thfilter1(c)
	return c:IsSetCard(0x1b9) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c98920743.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(81418467) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98920743.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c98920743.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920743.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98920743.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920743.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
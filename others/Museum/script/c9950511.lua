--神圣光辉复合大圣殿
function c9950511.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9950511.condition)
	e1:SetOperation(c9950511.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9950511)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9950511.thtg)
	e3:SetOperation(c9950511.thop)
	c:RegisterEffect(e3)
end
function c9950511.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsType(TYPE_LINK)
end
function c9950511.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c9950511.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xba5)
end
function c9950511.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950511,0))
end
function c9950511.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9950511.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950511.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950511.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9950511.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9950511.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950511,0))
end

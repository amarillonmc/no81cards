--人理之基 英灵卫宫
function c22020220.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020220,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,22020220)
	e1:SetCost(c22020220.cost)
	e1:SetTarget(c22020220.target)
	e1:SetOperation(c22020220.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020220,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22020220)
	e2:SetCondition(c22020220.thcon)
	e2:SetTarget(c22020220.target)
	e2:SetOperation(c22020220.operation)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020220,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,22020221)
	e3:SetTarget(c22020220.target1)
	e3:SetOperation(c22020220.operation1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
c22020220.effect_canequip_hogu=true
c22020220.effect_with_master=true
function c22020220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22020220.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1ff1)
end
function c22020220.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020220.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c22020220.filter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22020220.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22020220.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020220.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22020220.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22020220.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SelectOption(tp,aux.Stringid(22020220,3))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22020220.tgfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c22020220.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020220.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22020220.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22020220,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22020220.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
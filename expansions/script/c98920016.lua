--圣骑士 迪拿丹
function c98920016.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920016.hspcon)
	e1:SetOperation(c98920016.hspop)
	c:RegisterEffect(e1)	 
 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920016,0))	
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,98930016)
	e2:SetTarget(c98920016.tg)
	e2:SetOperation(c98920016.op)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)	
--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920016,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930016)
	e3:SetCost(c98920016.cost)
	e3:SetTarget(c98920016.target)
	e3:SetOperation(c98920016.operation)
	c:RegisterEffect(e3)
end
function c98920016.spcfilter(c)
	return (c:IsSetCard(0x107a) or c:IsSetCard(0x207a)) and c:IsAbleToGraveAsCost() 
end
function c98920016.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c98920016.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
end
function c98920016.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920016.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920016.filter(c)
	return c:IsLevel(4) and c:IsSetCard(0x107a) and c:IsAbleToHand()
end
function c98920016.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920016.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920016.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920016.filter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x207a) and c:IsAbleToHand()
end
function c98920016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920016.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920016.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920016.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--执棋者 -方舟骑士-
function c29065506.initial_effect(c)
	aux.AddCodeList(c,29065502)
	--add code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(29065502)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65518099,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29065506)
	e2:SetCost(c29065506.thco)
	e2:SetTarget(c29065506.thtg)
	e2:SetOperation(c29065506.thop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2414168,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c29065506.rmcon)
	e3:SetTarget(c29065506.rmtg)
	e3:SetOperation(c29065506.rmop)
	c:RegisterEffect(e3)
end
--e3
function c29065506.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return ep==tp and Duel.GetAttackTarget()==nil and tc:IsAbleToRemove(1-tp,POS_FACEDOWN,REASON_RULE)
end
function c29065506.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c29065506.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,1-tp)
	end
end
--e2
function c29065506.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c29065506.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c29065506.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065506.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065506.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065506.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--核成兽的外置钢核 
function c98920063.initial_effect(c)
	aux.AddCodeList(c,36623431)
		--change name
	aux.EnableChangeCode(c,36623431,LOCATION_HAND+LOCATION_GRAVE)   
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920063,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,98920063)
	e1:SetCondition(c98920063.drcon)
	e1:SetTarget(c98920063.drtg)
	e1:SetOperation(c98920063.drop)
	c:RegisterEffect(e1)   
 --to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920063,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98921063)
	e4:SetTarget(c98920063.thtg)
	e4:SetOperation(c98920063.thop)
	c:RegisterEffect(e4)
end
function c98920063.cfilter(c,tp)
	return ((c:IsSetCard(0x1d) and c:IsType(TYPE_MONSTER)) or c:IsCode(98920063)) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function c98920063.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920063.cfilter,1,nil,tp)
end
function c98920063.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920063.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(98920063,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c98920063.thfilter(c)
	return c:IsOriginalCodeRule(36623431) and c:IsAbleToHand()
end
function c98920063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920063.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98920063.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920063.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
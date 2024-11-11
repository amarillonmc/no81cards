function c10111140.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111140,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10111140)
	e1:SetCost(c10111140.spcost)
	e1:SetTarget(c10111140.damtg)
	e1:SetOperation(c10111140.damop)
	c:RegisterEffect(e1)
    	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101111400)
	e2:SetCondition(c10111140.thcon)
	e2:SetTarget(c10111140.thtg)
	e2:SetOperation(c10111140.thop)
	c:RegisterEffect(e2)
end
function c10111140.costfilter(c)
	return aux.IsCodeOrListed(c,10111128) and not c:IsCode(10111140) and c:IsAbleToGraveAsCost()
end
function c10111140.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111140.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10111140.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10111140.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c10111140.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c10111140.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and r==REASON_FUSION
end
function c10111140.thfilter(c)
	return not c:IsCode(10111140) and aux.IsCodeOrListed(c,10111128) and c:IsAbleToHand()
end
function c10111140.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111140.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10111140.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10111140.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
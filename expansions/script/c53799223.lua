local m=53799223
local cm=_G["c"..m]
cm.name="夜魔 BNGRG"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,function(g)return g:IsExists(Card.IsLinkType,1,nil,TYPE_FUSION)end)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost1)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCost(cm.thcost2)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)
end
function cm.limit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.costfilter1(c)
	return c:IsCode(24094653) and c:IsDiscardable()
end
function cm.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.costfilter1,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.thfilter1(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and not c:IsCode(24094653) and c:IsAbleToHand()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	cm.limit(e,tp,eg,ep,ev,re,r,rp)
end
function cm.costfilter2(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and not c:IsCode(24094653) and c:IsDiscardable()
end
function cm.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.costfilter2,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.thfilter2(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	cm.limit(e,tp,eg,ep,ev,re,r,rp)
end

--堕魔床
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_COST)
end
function cm.tgf1(c)
	return c:IsSetCard(0x3fd5) and ((c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
		or (c:IsType(TYPE_MONSTER) and c:IsAbleToHand()))
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tgf1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local c=Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if c and c:IsType(TYPE_MONSTER) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_MONSTER) then 
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		else
			Duel.SSet(tp,tc)
		end
		Duel.ConfirmCards(1-tp,tc)
	end
end
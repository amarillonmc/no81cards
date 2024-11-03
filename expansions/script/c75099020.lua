--炎剑之鞘 瑞瓦伽伦
function c75099020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75099020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c75099020.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75099020)
	e2:SetCost(c75099020.descost)
	e2:SetTarget(c75099020.destg)
	e2:SetOperation(c75099020.desop)
	c:RegisterEffect(e2)
c75099020.frozen_list=true
end
function c75099020.cfilter(c)
	return c:IsFaceupEx() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function c75099020.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c75099020.cfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c75099020.costfilter(c)
	return c.frozen_list and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c75099020.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75099020.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75099020.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
function c75099020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c75099020.thfilter(c)
	return c.frozen_list and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75099020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetLabelObject():IsLevelAbove(6) and Duel.IsExistingMatchingCard(c75099020.thfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(75099020,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c75099020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end

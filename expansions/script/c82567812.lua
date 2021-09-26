--方舟骑士·精神爆发 阿米娅
local m=82567812
local cm=_G["c"..m]
function c82567812.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(82567812,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82567812)
	e1:SetCost(c82567812.descost2)
	e1:SetTarget(c82567812.destg2)
	e1:SetOperation(c82567812.desop2)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567812,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82567712+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c82567812.target)
	e2:SetOperation(c82567812.activate)
	c:RegisterEffect(e2)
end
function c82567812.filter(c)
	return c:IsSetCard(0xa826) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c82567812.tdfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function c82567812.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567812.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c82567812.tdfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82567812.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c82567812.tdfilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c82567812.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g1:GetCount()~=0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	else
		Duel.ShuffleHand(tp)
	end
end
function c82567812.desfilter(c)
	return c:IsFaceup()  
end
function c82567812.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) and c:GetAttack()>=1600 end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST) 
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
end
function c82567812.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(c82567812.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c82567812.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,0)
end
function c82567812.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


	

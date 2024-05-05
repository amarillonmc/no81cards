--银河列车·与行星相会
function c78384653.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,78384653)
	e1:SetTarget(c78384653.target)
	e1:SetOperation(c78384653.activate)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,88384653)
	e2:SetCondition(c78384653.lvcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c78384653.lvtg)
	e2:SetOperation(c78384653.lvop)
	c:RegisterEffect(e2)
end
function c78384653.rmfilter(c)
	return c:IsSetCard(0x746) and c:IsAbleToRemove() and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c78384653.thfilter,c:GetControler(),LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c78384653.thfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsSetCard(0x746) and c:IsAbleToHand()
end
function c78384653.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c78384653.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectTarget(tp,c78384653.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c78384653.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c78384653.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c78384653.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c78384653.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78384653.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c78384653.lvfilter(c)
	return c:IsSetCard(0x746) and c:IsFaceup() and c:GetLevel()>0
end
function c78384653.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c78384653.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78384653.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c78384653.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c78384653.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sel=0
		local lvl=4
		if tc:IsLevelBelow(4) then
			sel=Duel.SelectOption(tp,aux.Stringid(78384653,0))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(78384653,0),aux.Stringid(78384653,1))
		end
		if sel==1 then
			lvl=-4
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

--忍鬼 萩野
function c40009050.initial_effect(c)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c40009050.rlevel)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009050,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009050)
	e2:SetCondition(c40009050.thcon)
	e2:SetTarget(c40009050.rctg)
	e2:SetOperation(c40009050.rcop)
	c:RegisterEffect(e2)	
end
function c40009050.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2b) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c40009050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c40009050.filter(c)
	return c:IsAbleToDeck() and (c:IsSetCard(0x61) or (c:IsSetCard(0x2b) and c:IsType(TYPE_MONSTER)))
end
function c40009050.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40009050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009050.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40009050.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40009050.rcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
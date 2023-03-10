--魔偶甜点糖果屋
function c98920007.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98920007.target)
	e1:SetOperation(c98920007.activate)	
	c:RegisterEffect(e1)  
  --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x71))
	e3:SetValue(c98920007.efilter)
	c:RegisterEffect(e3) 
   --to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920007,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c98920007.target3)
	e3:SetOperation(c98920007.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function c98920007.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c98920007.filter(c)
	return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and
	Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)>=c:GetLevel()
end
function c98920007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function c98920007.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920007.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		local maxn=g:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		local minn=g:GetMinGroup(Card.GetLevel):GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,minn,maxn,nil)
		if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,nil,REASON_EFFECT) then
			local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
			if g:IsExists(Card.IsLevel,1,nil,ct) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				g=g:FilterSelect(tp,Card.IsLevel,1,1,nil,ct)
				if #g>0 and Duel.SendtoHand(g,nil,2,REASON_EFFECT) then
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function c98920007.filter3(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x71)
end
function c98920007.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98920007.filter3(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c98920007.filter3,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920007.filter3,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,LOCATION_MZONE)
end
function c98920007.operation3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
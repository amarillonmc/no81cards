--端午节的觉醒萤草
function c8709009.initial_effect(c)
	   --xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c8709009.ovfilter,aux.Stringid(8709009,0),2,c8709009.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8709009.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c8709009.defval)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8709009,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8709009.spcost1)
	e3:SetTarget(c8709009.drtg)
	e3:SetOperation(c8709009.drop)
	c:RegisterEffect(e3)
end
function c8709009.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) and not c:IsCode(8709009)
end
function c8709009.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,8709009)==0 end
	Duel.RegisterFlagEffect(tp,8709009,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c8709009.atkfilter(c)
	return c:IsSetCard(0xafa) and c:GetAttack()>=0
end
function c8709009.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709009.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c8709009.deffilter(c)
	return c:IsSetCard(0xafa) and c:GetDefense()>=0
end
function c8709009.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709009.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c8709009.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8709009.tdfilter(c)
	return c:IsSetCard(0xafa) and c:IsAbleToDeck()
end
function c8709009.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8709009.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c8709009.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c8709009.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c8709009.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


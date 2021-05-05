--银河中央监狱
function c40009623.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40009623.ovcon)
	e2:SetTarget(c40009623.ovtg)
	e2:SetOperation(c40009623.ovop)
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c40009623.efilter)
	c:RegisterEffect(e3) 
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009623,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c40009623.drcost)
	e4:SetCondition(c40009623.dhcon)
	e4:SetTarget(c40009623.drtg)
	e4:SetOperation(c40009623.drop)
	c:RegisterEffect(e4) 
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009623,2))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(c40009623.thcost)
	e5:SetCondition(c40009623.dhcon)
	e5:SetTarget(c40009623.thtg)
	e5:SetOperation(c40009623.thop)
	c:RegisterEffect(e5)
end
function c40009623.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c40009623.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c40009623.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009623.ovfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009623.ovfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40009623.ovfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c40009623.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:GetOverlayCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40009623,0))
		local mg=c:GetOverlayGroup():Select(tp,1,1,nil)
		local oc=mg:GetFirst():GetOverlayTarget()
		Duel.Overlay(tc,mg)
		Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	end
end
function c40009623.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c40009623.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40009623.dhcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and tp~=e:GetHandler():GetControler()
end
--tp~=e:GetHandler():GetControler()
function c40009623.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c40009623.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009623.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local lg=e:GetHandler():GetOverlayGroup()
		if lg:IsExists(c40009623.spfilter,1,nil,e,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=lg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c40009623.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c40009623.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)
end
function c40009623.thfilter(c)
	return c:IsAbleToHand()
end
function c40009623.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local lg=e:GetHandler():GetOverlayGroup()
		if lg:IsExists(c40009623.thfilter,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=lg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--天玲 永远的羁绊
function c60150618.initial_effect(c)
	aux.AddXyzProcedure(c,c60150618.mfilter,4,2)
	c:EnableReviveLimit()
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(60150618)
	c:RegisterEffect(e12)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c60150618.tgtg)
	e4:SetOperation(c60150618.tgop)
	c:RegisterEffect(e4)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c60150618.thcost)
	e1:SetTarget(c60150618.thtg)
	e1:SetOperation(c60150618.thop)
	c:RegisterEffect(e1)
end
function c60150618.mfilter(c)
	return c:IsSetCard(0x3b21)
end
function c60150618.tgfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER)
end
function c60150618.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150618.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60150618.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150618.gfilter2(c)
	return c:IsAbleToGrave()
end
function c60150618.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150618.tgfilter,tp,LOCATION_DECK,0,nil)
	local g2=g:Filter(c60150618.gfilter,nil)
	local g3=g:Filter(c60150618.gfilter2,nil)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	elseif g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	else 
		return false
	end
end
function c60150618.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150618.tgfilter2(c)
	return true
end
function c60150618.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150618.tgfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c60150618.tgfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
end
function c60150618.gfilter3(c)
	return c:IsAbleToDeck()
end
function c60150618.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150618.tgfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=g:Filter(c60150618.gfilter,nil)
	local g3=g:Filter(c60150618.gfilter3,nil)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	elseif g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	else 
		return false
	end
end
function c60150618.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c60150618.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_DARK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_ADD_ATTRIBUTE)
	e12:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e12:SetValue(ATTRIBUTE_EARTH)
	e12:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e12)
end
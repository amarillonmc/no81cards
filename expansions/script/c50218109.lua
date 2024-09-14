--水之数码兽LV7 祖顿兽
function c50218109.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,50218109)
	e4:SetCondition(c50218109.discon)
	e4:SetTarget(c50218109.distg)
	e4:SetOperation(c50218109.disop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,50218009)
	e5:SetCost(c50218109.scost)
	e5:SetTarget(c50218109.stg)
	e5:SetOperation(c50218109.sop)
	c:RegisterEffect(e5)
end
c50218109.lvup={50218108}
c50218109.lvdn={50218108,50218107}
function c50218109.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex0,tg0,tc0=Duel.GetOperationInfo(ev,CATEGORY_RELEASE)
	local ex1,tg1,tc1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2,tg2,tc2=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	local ex3,tg3,tc3=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA)
	local ex4,tg4,tc4=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex5,tg5,tc5=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return (ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0)
		or (ex0 and tg0~=nil and tc0+tg0:FilterCount(Card.IsOnField,nil)-tg0:GetCount()>0)
		or (ex1 and tg1~=nil and tc1+tg1:FilterCount(Card.IsOnField,nil)-tg1:GetCount()>0)
		or (ex2 and tg2~=nil and tc2+tg2:FilterCount(Card.IsOnField,nil)-tg2:GetCount()>0)
		or (ex3 and tg3~=nil and tc3+tg3:FilterCount(Card.IsOnField,nil)-tg3:GetCount()>0)
		or (ex4 and tg4~=nil and tc4+tg4:FilterCount(Card.IsOnField,nil)-tg4:GetCount()>0)
		or (ex5 and tg5~=nil and tc5+tg5:FilterCount(Card.IsOnField,nil)-tg5:GetCount()>0)
end
function c50218109.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c50218109.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c50218109.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c50218109.sfilter(c)
	return c:IsSetCard(0xcb1) and not c:IsCode(50218109) and c:IsRace(RACE_AQUA) and c:IsAbleToHand()
end
function c50218109.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c50218109.sfilter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_HAND)
end
function c50218109.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c50218109.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--『星光歌剧』台本-约定Revue
function c64832026.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64832026)
	e1:SetCost(c64832026.cost)
	e1:SetTarget(c64832026.tg)
	e1:SetOperation(c64832026.op)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,64832027)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c64832026.drtg)
	e2:SetOperation(c64832026.drop)
	c:RegisterEffect(e2)
end
function c64832026.costfil(c,tp)
	return c:IsSetCard(0x6410) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c64832026.costfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c64832026.costfilter(c,code)
	return c:IsSetCard(0x6410) and not c:IsCode(code) and c:IsAbleToHand()
end
function c64832026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64832026.costfil,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c64832026.costfil,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetCode())   
end
function c64832026.thfil(c)
	return c:IsSetCard(0x6410) and not c:IsCode(64832026) and c:IsAbleToHand()
end
function c64832026.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c64832026.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c64832026.costfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetLabel(e:GetLabel())
		e1:SetCondition(c64832026.actcon)
		e1:SetValue(c64832026.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAINING)
		e2:SetLabel(e:GetLabel())
		e2:SetOperation(c64832026.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c64832026.actcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),64832026)~=0
end
function c64832026.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(e:GetLabel())
end
function c64832026.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) or not re:GetHandler():IsCode(e:GetLabel()) then return end
	Duel.RegisterFlagEffect(tp,64832026,RESET_PHASE+PHASE_END,0,1)
end
function c64832026.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c64832026.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
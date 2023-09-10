--魔导学者 佩塔
function c98920691.initial_effect(c) 
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2)
	--to deck and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920691,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920691.con)
	e1:SetCountLimit(1,98920691)
	e1:SetTarget(c98920691.tg)
	e1:SetOperation(c98920691.op)
	c:RegisterEffect(e1)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920691,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,98930691)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98920691.cost)
	e3:SetOperation(c98920691.damop)
	c:RegisterEffect(e3)
	if c98920691.counter==nil then
		c98920691.counter=true
		c98920691[0]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c98920691.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(c98920691.regcon)
		e5:SetOperation(c98920691.addcount)
		Duel.RegisterEffect(e5,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetCondition(c98920691.regcon)
		e2:SetOperation(c98920691.regop2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,0)
	end
end
function c98920691.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c98920691.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920691.filter(c)
	return (c:IsRace(RACE_SPELLCASTER) or c:IsSetCard(0x106e)) and c:IsAbleToDeck()
end
function c98920691.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920691.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920691.filter,tp,LOCATION_GRAVE,0,5,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c98920691.filter,tp,LOCATION_GRAVE,0,5,5,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c98920691.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c98920691.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920691.gfilter(c,dam)
	return c:IsAttackBelow(dam) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c98920691.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dam=c98920691[0]*200
	if chk==0 then return Duel.IsExistingMatchingCard(c98920691.gfilter,tp,LOCATION_DECK,0,1,nil,dam) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920691.damop(e,tp,eg,ep,ev,re,r,rp)
	if c98920691[0]>0 then
		local ct=c98920691[0]*200
		if Duel.Damage(1-tp,ct,REASON_EFFECT)~=0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local g=Duel.SelectMatchingCard(tp,c98920691.gfilter,tp,LOCATION_DECK,0,1,1,nil,ct)
		   if g:GetCount()>0 then
			   Duel.SendtoHand(g,nil,REASON_EFFECT)
			   Duel.ConfirmCards(1-tp,g)
			   local e1=Effect.CreateEffect(e:GetHandler())
			   e1:SetType(EFFECT_TYPE_FIELD)
			   e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			   e1:SetValue(c98920691.aclimit)
			   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			   e1:SetTargetRange(1,0)
			   e1:SetLabel(g:GetFirst():GetCode())
			   e1:SetReset(RESET_PHASE+PHASE_END)
			   Duel.RegisterEffect(e1,tp)
		   end
	   end
	end
end
function c98920691.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function c98920691.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c98920691[0]=0
end
function c98920691.addcount(e,tp,eg,ep,ev,re,r,rp)
	c98920691[0]=c98920691[0]+1
end
function c98920691.regop2(e,tp,eg,ep,ev,re,r,rp)
	c98920691[0]=c98920691[0]-1
end
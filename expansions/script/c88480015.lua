--熵增焓变热寂龙
function c88480015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM),7,2,c88480015.ovfilter,aux.Stringid(88480015,0),2,c88480015.xyzop)
	c:EnableReviveLimit()
	--cannot be targeted
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88480015,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88480015)
	e2:SetCondition(c88480015.negcon)
	e2:SetCost(c88480015.negcost)
	e2:SetTarget(aux.nbtg)
	e2:SetOperation(c88480015.negop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88480015,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,88480015+1)
	e3:SetCondition(c88480015.ddcon)
	e3:SetCost(c88480015.negcost)
	e3:SetTarget(c88480015.ddtg)
	e3:SetOperation(c88480015.ddop)
	c:RegisterEffect(e3)
	if not c88480015.global_check then
		c88480015.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c88480015.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c88480015.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WYRM)
end
function c88480015.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,88480015)>0 and Duel.GetFlagEffect(tp,88480015+1)==0 end
	Duel.RegisterFlagEffect(tp,88480015+1,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c88480015.check(c)
	return c and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WYRM)
end
function c88480015.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c88480015.check(Duel.GetAttacker()) or c88480015.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,88480015,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,88480015,RESET_PHASE+PHASE_END,0,1)
	end
end
function c88480015.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and ep==1-tp
end
function c88480015.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88480015.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c88480015.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c88480015.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	if chk==0 then return #g1>0 and #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c88480015.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
	end
end
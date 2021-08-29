--超终焉钢战-魔神ZERO
function c82550000.initial_effect(c)
	 --xyz summon
	c:EnableReviveLimit()
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c82550000.fuslimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82550000,0))
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_CHAINING)
	e7:SetCountLimit(1,82550000)
	e7:SetCondition(c82550000.imcon)
	e7:SetHintTiming(TIMING_DAMAGE_STEP)
	e7:SetCost(c82550000.imcost)
	e7:SetOperation(c82550000.imoperation)
	c:RegisterEffect(e7)
	--remove
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(82550000,1))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,82550001)
	e8:SetHintTiming(0,TIMING_END_PHASE)
	e8:SetTarget(c82550000.rmtg)
	e8:SetOperation(c82550000.rmop)
	c:RegisterEffect(e8)
	--negate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(82550000,2))
	e9:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e9:SetCode(EVENT_CHAINING)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetCountLimit(1,82550002)
	e9:SetTarget(c82550000.negtg)
	e9:SetOperation(c82550000.negop)
	c:RegisterEffect(e9)
end
function c82550000.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c82550000.imcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c82550000.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c82550000.imoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c82550000.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c82550000.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82550000.exrmilter(c)
	return c:IsAbleToRemove() and c:IsFacedown()
end
function c82550000.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,4)
	local exg=Duel.GetMatchingGroup(c82550000.exrmilter,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==4
		and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=4
		and exg:GetCount()>=2 and Duel.GetTurnPlayer()==1-tp end
	 Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,6,1-tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c82550000.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,4)
	local exg=Duel.GetMatchingGroup(c82550000.exrmilter,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==4
		and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=4
		and exg:GetCount()>=2 end
	local rg=exg:RandomSelect(tp,2)
	g:Merge(rg)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c82550000.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c82550000.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
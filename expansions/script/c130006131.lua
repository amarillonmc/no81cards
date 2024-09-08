--神曲的魔导书
function c130006131.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c130006131.negcost)
	e1:SetCondition(c130006131.negcon)
	e1:SetTarget(c130006131.negtg)
	e1:SetOperation(c130006131.negop)
	c:RegisterEffect(e1) 
		if not c130006131.global_check then
		c130006131.global_check=true
		c130006131[0]={}
		c130006131[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c130006131.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c130006131.regop2)
		Duel.RegisterEffect(ge2,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(c130006131.clearop)
		Duel.RegisterEffect(ge4,0)
	end
	--act qp/trap in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(c130006131.handcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=e2:Clone() 
	e4:SetCode(130006131)
	c:RegisterEffect(e4)
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCost(c130006131.costchk)
	e5:SetTarget(c130006131.costtg)
	e5:SetOperation(c130006131.costop)
	c:RegisterEffect(e5)
	--retrieval
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,130106131)
	e6:SetTarget(c130006131.regtg)
	e6:SetOperation(c130006131.regop)
	c:RegisterEffect(e6)
end
function c130006131.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_PSYCHO) then
		local rc=re:GetHandler():GetCode()
		if c130006131[rp][rc] then c130006131[rp][rc]=c130006131[rp][rc]+1 else c130006131[rp][rc]=1 end
	end
end
function c130006131.regop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler():GetCode()
	if c130006131[rp][rc] then c130006131[rp][rc]=c130006131[rp][rc]-1 else c130006131[rp][rc]=nil end
end
function c130006131.clearop(e,tp,eg,ep,ev,re,r,rp)
	c130006131[0]={}
	c130006131[1]={}
end
function c130006131.spfilter1(c,rp)
	local rc=c:GetCode()
	return c:IsAbleToRemoveAsCost() and not c:IsCode(130006131) and c130006131[rp][rc]
end
function c130006131.spfilter2(c,rp)
	local rc=c:GetCode()
	return c:IsAbleToRemove() and c130006131[rp][rc]
end
function c130006131.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130006131.spfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c130006131.spfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c130006131.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c130006131.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c130006131.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end
function c130006131.handcon(e)
	return e:GetHandler():IsAbleToRemove()
end
function c130006131.costtg(e,te,tp)
	local tc=te:GetHandler()
	return  tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(130006131)>0
			and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(130006131) and tc:IsType(TYPE_QUICKPLAY))
			or (tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(130006131) and tc:IsType(TYPE_TRAP)))
end
function c130006131.costchk(e)
	return e:GetHandler():IsAbleToRemove()
end
function c130006131.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
function c130006131.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c130006131.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c130006131.spfilter2,tp,LOCATION_DECK,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c130006131.spfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
		if tg:GetCount()<=0 then return end
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
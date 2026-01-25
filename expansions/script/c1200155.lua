--Kakkakikkare 便石
function c1200155.initial_effect(c)
	aux.AddCodeList(c,1200125)
	aux.AddCodeList(c,1200130)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_COIN)
	e2:SetCountLimit(1,1200156)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c1200155.cefop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--change position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200155,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,1200155)
	e4:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1200155.postg)
	e4:SetOperation(c1200155.posop)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1200155,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1200155.adcon)
	e5:SetCost(c1200155.adcost)
	e5:SetTarget(c1200155.adtg)
	e5:SetOperation(c1200155.adop)
	c:RegisterEffect(e5)
	
end
c1200155.toss_coin=true
function c1200155.cefop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_COIN)
	--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c1200155.con)
	e1:SetOperation(c1200155.op)
	Duel.RegisterEffect(e1,tp)
end

function c1200155.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==Duel.GetTurnPlayer()
end
function c1200155.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if re:GetHandler()==e:GetHandler() then return end
	local c1,c2=Duel.TossCoin(ep,2)
	if c1+c2==2 then
		Duel.Hint(HINT_CARD,0,1200155)
		Duel.ChangeChainOperation(ev,c1200155.repop)
	end
end
function c1200155.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1200155)
	local c=e:GetHandler()
	--if c:IsRelateToEffect(e) then
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT,tp,true)
	--end
end

function c1200155.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c1200155.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end

function c1200155.adcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==Duel.GetTurnPlayer() and e:GetHandler():IsFacedown()
end
function c1200155.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c1200155.spadfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c1200155.adfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c1200155.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200155.spadfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c1200155.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1200155.spadfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end

function c1200155.destg(e,c)
	return c:GetOwner()==Duel.GetTurnPlayer()
end
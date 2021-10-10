--灵刀域 量子重叠
function c60001047.initial_effect(c)
	c:SetUniqueOnField(1,0,60001047)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c60001047.con)
	e1:SetCountLimit(1,60001047)
	c:RegisterEffect(e1)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60001047.discon)
	e4:SetOperation(c60001047.disop)
	c:RegisterEffect(e4)
	--disable2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60001047.discon1)
	e4:SetOperation(c60001047.disop1)
	c:RegisterEffect(e4)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001047,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001047)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60001047.settg)
	e2:SetOperation(c60001047.setop)
	c:RegisterEffect(e2)
end
function c60001047.cfilter0(c)
	return c:IsFaceup() and c:IsSetCard(0x624)
end
function c60001047.con(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)
	return g:IsExists(c60001047.cfilter0,1,nil)
end
function c60001047.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsSetCard(0x624) and seq1==4-seq2
end
function c60001047.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c60001047.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c60001047.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60001047)
	Duel.NegateEffect(ev)
end
function c60001047.cfilter1(c,seq4)
	local seq3=aux.SZoneSequence(c:GetSequence())
	return c:IsSetCard(0x624) and seq3==4-seq4
end
function c60001047.discon1(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.SZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c60001047.cfilter1,tp,LOCATION_SZONE,0,1,nil,seq)
end
function c60001047.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60001047)
	Duel.NegateEffect(ev)
end
function c60001047.stfilter(c)
	return c:IsSetCard(0x624) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c60001047.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c60001047.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c60001047.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c60001047.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
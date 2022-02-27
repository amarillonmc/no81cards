--电子音姬 House
function c33200660.initial_effect(c)
	c:SetSPSummonOnce(33200660)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),4,2)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33200660.discon)
	e1:SetOperation(c33200660.disop)
	c:RegisterEffect(e1) 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e0:SetOperation(c33200660.cop)
	c:RegisterEffect(e0)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200660,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200660)
	e2:SetTarget(c33200660.atktg)
	e2:SetOperation(c33200660.atkop)
	c:RegisterEffect(e2)
end

--e1
function c33200660.cop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then
		e:GetHandler():RegisterFlagEffect(33200660,RESET_PHASE+PHASE_END,0,1)
	end
end
function c33200660.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:GetFlagEffect(33200660)~=0 and seq1==4-seq2
end
function c33200660.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) and loc==LOCATION_SZONE
		and Duel.IsExistingMatchingCard(c33200660.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c33200660.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33200660)
	Duel.NegateEffect(ev)
end

--e2
function c33200660.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33200660.atkop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

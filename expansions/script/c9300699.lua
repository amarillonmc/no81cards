--特殊技能暂抽取
function c9300699.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9300699.cost)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9300699.discon)
	e2:SetOperation(c9300699.disop)
	c:RegisterEffect(e2)
end
function c9300699.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c9300699.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	return tc:IsStatus(STATUS_SPSUMMON_TURN)
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and bit.band(pos,POS_FACEUP)~=0
end
function c9300699.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end










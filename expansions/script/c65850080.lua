--极简应对
function c65850080.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetDescription(aux.Stringid(65850080,0))
	c:RegisterEffect(e0)
	--效果
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65850080+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65850080.discon)
	e1:SetTarget(c65850080.distg)
	e1:SetOperation(c65850080.disop)
	c:RegisterEffect(e1)
end

function c65850080.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and (te:GetHandler():IsRace(RACE_INSECT) or te:GetHandler():IsSetCard(0xa35)) and p==tp and rp==1-tp
end
function c65850080.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and Duel.IsChainDisablable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetTargetCard(ng)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ng,ng:GetCount(),0,0)
end
function c65850080.disop(e,tp,eg,ep,ev,re,r,rp)
	--limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850080.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and Duel.NegateEffect(i) then
			local tc=te:GetHandler()
			dg:AddCard(tc)
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c65850080.splimit(e,c)
	return not c:IsSetCard(0xa35)
end
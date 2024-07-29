--锦上添花之月神
function c9910067.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9910067.mat,1,1)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910067.regcon)
	e1:SetOperation(c9910067.regop)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910067,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910067.actcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9951))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910067,ACTIVITY_CHAIN,c9910067.chainfilter)
end
function c9910067.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_FAIRY) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9910067.mat(c)
	return c:IsLinkSetCard(0x9951) and not c:IsLinkType(TYPE_LINK)
end
function c9910067.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910067.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetMaterial():GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(math.max(tc:GetBaseAttack(),tc:GetBaseDefense()))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c9910067.actcon(e)
	return Duel.GetCustomActivityCount(9910067,0,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9910067,1,ACTIVITY_CHAIN)~=0
end

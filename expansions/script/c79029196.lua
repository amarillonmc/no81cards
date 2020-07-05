--罗德岛·近卫干员-刻刀
function c79029196.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c79029196.spcon)
	e1:SetTarget(c79029196.sptg)
	e1:SetCountLimit(1,79029196)
	e1:SetOperation(c79029196.spop)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029196.limit)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029196.limit)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029196.limit)
	c:RegisterEffect(e2)	
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029196.limit)
	c:RegisterEffect(e2)  
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c79029196.efcon)
	e3:SetOperation(c79029196.efop)
	c:RegisterEffect(e3)   
end
function c79029196.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xa900)
end
function c79029196.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp,g)>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
end
function c79029196.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g then
	   g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c79029196.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	g:DeleteGroup()
end
function c79029196.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:IsSetCard(0xa900)
end
function c79029196.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029196)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(4290468,1))
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029196.atcon)
	e1:SetOperation(c79029196.dpop)
	rc:RegisterEffect(e1)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029196,0))
end
function c79029196.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_DECKSHF,0,1,nil)
end  
function c79029196.dpop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(g,REASON_COST)~=0 then
	Duel.ChainAttack()
end
end

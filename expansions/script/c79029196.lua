--罗德岛·近卫干员-刻刀
function c79029196.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c79029196.spcon)
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
function c79029196.spfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c79029196.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029196.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c79029196.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029196.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	Debug.Message("了解。刻刀入队了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029196,1))
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029196.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79029196.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900)
end
function c79029196.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:IsSetCard(0xa900) and bit.band(r,REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)~=0  
end 
function c79029196.efop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("刀子，擦亮了吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029196,2))
	Duel.Hint(HINT_CARD,0,79029196)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(4290468,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029196.atcon)
	e1:SetOperation(c79029196.dpop)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
	rc:RegisterFlagEffect(79029196,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029196,0))
end
function c79029196.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_DECKSHF,0,1,nil)
end  
function c79029196.dpop(e,tp,eg,ep,ev,re,r,rp,c)
	Debug.Message("你慢了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029196,3))
	local g=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(g,REASON_COST)~=0 then
	Duel.ChainAttack()
end
end

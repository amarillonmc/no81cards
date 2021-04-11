--罗德岛·近卫干员-杰克
function c79029349.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c79029349.spcon)
	e1:SetTarget(c79029349.sptg)
	e1:SetCountLimit(1,79029349)
	e1:SetOperation(c79029349.spop)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029349.limit)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029349.limit)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029349.limit)
	c:RegisterEffect(e2)	
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029349.limit)
	c:RegisterEffect(e2)  
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c79029349.efcon)
	e3:SetOperation(c79029349.efop)
	c:RegisterEffect(e3)	   
end

function c79029349.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xa900)
end
function c79029349.spctfil(c)
	return c:IsDiscardable() and (c:IsSetCard(0xa900) or c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d))
end
function c79029349.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp,g)>0 and Duel.IsExistingMatchingCard(c79029349.spctfil,tp,LOCATION_HAND,0,1,nil)
end
function c79029349.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c79029349.spctfil,tp,LOCATION_HAND,0,nil)
	if g then
	   g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c79029349.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Debug.Message("我来啦！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029349,1))
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	g:DeleteGroup()
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029349.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79029349.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900)
end
function c79029349.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:IsSetCard(0xa900) and bit.band(r,REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)~=0  
end
function c79029349.efop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("热身完毕！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029349,2))
	Duel.Hint(HINT_CARD,0,79029349)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--
	local e2=Effect.CreateEffect(rc)
	e2:SetDescription(aux.Stringid(79029349,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029349.negcon)
	e2:SetOperation(c79029349.negop)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2)
	rc:RegisterFlagEffect(79029349,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029349,0))
end
function c79029349.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c79029349.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) and Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) then
	Debug.Message("可不要小看我啦！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029349,3))
	Duel.NegateActivation(ev) 
	end
end
















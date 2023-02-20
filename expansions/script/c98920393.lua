--凶导之白天顶
function c98920393.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920393.splimit)
	c:RegisterEffect(e1)
--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c98920393.sdcon)
	c:RegisterEffect(e1)
--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c98920393.actlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c98920393.target)
	c:RegisterEffect(e3)
--
   local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetLabel(0) 
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(c98920393.damcon1)
	e10:SetOperation(c98920393.checkop)
	c:RegisterEffect(e10)
end
function c98920393.sdfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920393.sdcon(e)
	return Duel.IsExistingMatchingCard(c98920393.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98920393.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL~=SUMMON_TYPE_RITUAL or (se and se:GetHandler():IsSetCard(0x145))
end
function c98920393.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOnField() and rc:IsSummonLocation(LOCATION_EXTRA)
end
function c98920393.target(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920393.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),98920393,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
	if Duel.GetFlagEffect(1-tp,98920393)~=5 then return false end
	if Duel.GetFlagEffect(tp,98920393)>0 then
		e:Reset()
	end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		local WIN_REASON_NUMERONIUS_NUMERONIA=0x21
		Duel.Win(tp,WIN_REASON_NUMERONIUS_NUMERONIA)
	end
end
function c98920393.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920393.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920393.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920393.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920393.filter,1,nil,1-tp)
end
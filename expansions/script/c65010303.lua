--ANOTHER RIDER KUUGA
function c65010303.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010303,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010303)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(c65010303.hspcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65010303,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetCountLimit(1,65010303)
	e2:SetCondition(c65010303.spcon2)
	c:RegisterEffect(e2)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c65010303.spcon)
	e2:SetTarget(c65010303.splimit)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c65010303.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c65010303.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65010303,2))
end
function c65010303.filter(c)
	return c:IsSetCard(0xcda0) and c:IsType(TYPE_MONSTER)
end
function c65010303.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c65010303.filter,tp,0,LOCATION_MZONE,1,nil) 
end
function c65010303.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xcda0) and c:IsLocation(LOCATION_EXTRA+LOCATION_DECK)
end
function c65010303.cfilter(c)
	return c:GetColumnGroupCount()<1
end
function c65010303.hspcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c65010303.cfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,1-tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)<1 or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function c65010303.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcda0)
end
function c65010303.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65010303.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
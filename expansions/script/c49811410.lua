--龙继承者-龙之崇拜者-
function c49811410.initial_effect(c)
	--alstroemeria spsummon-hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,49811410+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c49811410.spcon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c49811410.rmlimit)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,49811410)
	e4:SetTarget(c49811410.settg)
	e4:SetOperation(c49811410.setop)
	c:RegisterEffect(e4)
end
function c49811410.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function c49811410.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c49811410.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetMZoneCount(e:GetHandlerPlayer())>0
end
function c49811410.rmlimit(e,c,rp,r,re)
	return c:IsRace(RACE_DRAGON) and c:IsOnField() and r&REASON_EFFECT>0 and rp~=e:GetHandlerPlayer()
end
function c49811410.setfilter(c)
	return c:IsCode(24094653,71490127) and c:IsSSetable()
end
function c49811410.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811410.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c49811410.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811410.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if sc then Duel.SSet(tp,sc) end
end

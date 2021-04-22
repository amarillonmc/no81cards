--怠惰的魅魔
function c60159911.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57774843,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c60159911.spcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c60159911.sumlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(c60159911.aclimit)
	c:RegisterEffect(e5)
	--return control
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c60159911.ctcon)
	e6:SetTarget(c60159911.cttg)
	e6:SetOperation(c60159911.ctop)
	c:RegisterEffect(e6)
end
function c60159911.spfilter(c)
	return bit.band(c:GetSummonLocation(),LOCATION_EXTRA+LOCATION_GRAVE)~=0 and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c60159911.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c60159911.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c60159911.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and e:GetHandler():GetSummonLocation()==LOCATION_HAND and e:GetHandler():IsFaceup() and c:IsLocation(LOCATION_EXTRA+LOCATION_GRAVE) 
end
function c60159911.aclimit(e,re,tp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and e:GetHandler():GetSummonLocation()==LOCATION_HAND and e:GetHandler():IsFaceup() and re:IsActiveType(TYPE_MONSTER) and bit.band(re:GetHandler():GetSummonLocation(),LOCATION_EXTRA+LOCATION_GRAVE)~=0
		and not re:GetHandler():IsImmuneToEffect(e)
end
function c60159911.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c60159911.ctfilter(c)
	return bit.band(c:GetSummonLocation(),LOCATION_EXTRA+LOCATION_GRAVE)~=0 and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c60159911.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159911.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c60159911.ctop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c60159911.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

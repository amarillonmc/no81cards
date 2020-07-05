--梦幻崩界 伊娃力丝·终罪
function c79029512.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,7,7,c79029512.lcheck)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)   
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c79029512.atkval)
	c:RegisterEffect(e2)
	--disable field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetOperation(c79029512.disop1)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c79029512.efilter)
	c:RegisterEffect(e4)
	--cannot release
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6) 
	--cannot target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--SpecialSummon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCondition(c79029512.spcon)
	e8:SetTarget(c79029512.sptg)
	e8:SetOperation(c79029512.spop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e9)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e9)
	local e9=e8:Clone()
	e9:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e9)
end
function c79029512.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,10158145) and g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c79029512.atkval(e,c)
	local g=e:GetHandler():GetMaterialCount()
	return g*1500
end
function c79029512.disop1(e,tp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0xffffff00)
	return zone
end
function c79029512.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029512.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_RULE)~=0
end
function c79029512.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029512.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end







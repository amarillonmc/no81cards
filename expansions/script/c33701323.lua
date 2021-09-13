--虚拟YouTuber 绊爱 SP
function c33701323.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_LINK)
	e1:SetCondition(c33701323.spcon)
	e1:SetOperation(c33701323.spop)
	c:RegisterEffect(e1)
	--cannot be material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetValue(c33701323.synlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
end
function c33701323.spfil(c)
	return c:IsCanBeLinkMaterial(nil) and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsRace(RACE_CYBERSE))
end
function c33701323.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c33701323.spfil,tp,LOCATION_ONFIELD,0,2,nil)
end
function c33701323.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33701323.spfil,tp,LOCATION_ONFIELD,0,2,2,nil)
	e:GetHandler():SetMaterial(g)
	Duel.SendtoGrave(g,REASON_LINK+REASON_MATERIAL)
end
function c33701323.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x445) and c:IsLocation(LOCATION_EXTRA)
end










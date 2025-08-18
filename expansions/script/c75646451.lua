--全域联结 菲米莉丝
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.mfilter,1)
	--effect gain 2link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(700)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	--gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.con2)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	--effect gain 5link
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.immtg)
	e5:SetValue(aux.tgoval)
	--Indes
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(aux.indoval)
	--gain
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCondition(s.con5)
	e7:SetLabelObject(e5)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetLabelObject(e6)
	c:RegisterEffect(e8)
	--effect gain 8link
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_UNRELEASABLE_SUM)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetTarget(s.intg)
	e11:SetValue(1)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	local e13=e11:Clone()
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e13:SetValue(s.fuslimit)
	local e14=e11:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	local e15=e11:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	--gain
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e16:SetRange(LOCATION_MZONE)
	e16:SetTargetRange(LOCATION_MZONE,0)
	e16:SetCondition(s.con8)
	e16:SetLabelObject(e11)
	c:RegisterEffect(e16)
	local e17=e16:Clone()
	e17:SetLabelObject(e12)
	c:RegisterEffect(e17)
	local e18=e16:Clone()
	e18:SetLabelObject(e13)
	c:RegisterEffect(e18)
	local e19=e16:Clone()
	e19:SetLabelObject(e14)
	c:RegisterEffect(e19)
	local e20=e16:Clone()
	e20:SetLabelObject(e15)
	c:RegisterEffect(e20)
end
function s.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2 and c:IsLinkRace(RACE_CYBERSE)
end
function s.con2(e)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	return mg:GetFirst():GetLink()>1
end
function s.immtg(e,c) 
	local seq1=e:GetHandler():GetSequence()
	local seq2=c:GetSequence()
	return (seq2<5 and seq1<5 and math.abs(seq1-seq2)==1) or (c:IsFaceup() and c:IsCode(id))
end
function s.con5(e)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	return mg:GetFirst():GetLink()>4
end
function s.intg(e,c)
	return (e:GetHandler():GetLinkedGroup():IsContains(c)) or (c:IsFaceup() and c:IsCode(id))
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.con8(e)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	return mg:GetFirst():GetLink()>7
end
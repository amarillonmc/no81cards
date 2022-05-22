--last upd 2022-2-24
Seine_Vocaloid={}
local sv=_G["Seine_Vocaloid"]
sv.field=31417010
sv.arcode=0x3316
function sv.enable(c,label)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,sv.field)
	e1:SetCondition(sv.spcon)
	e1:SetTarget(sv.sptg)
	e1:SetOperation(sv.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(0x1ff)
	e2:SetOperation(sv.completeProc)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(sv.fieldop)
	e3:SetLabel(label)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(sv.field)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	local e5_1=Effect.CreateEffect(c)
	e5_1:SetType(EFFECT_TYPE_SINGLE)
	e5_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5_1:SetValue(sv.mlimit)
	c:RegisterEffect(e5_1)
	local e5_2=e5_1:Clone()
	e5_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5_2)
	local e5_3=e5_1:Clone()
	e5_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5_3)
	local e5_4=e5_1:Clone()
	e5_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5_4)
end
function sv.mlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function sv.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	return (not c) or c:GetCode()~=sv.field
end
function sv.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function sv.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function sv.completeProc(e,tp,eg,ep,ev,re,r,rp)
	if re and re:IsActivated() and re:GetHandler():IsSetCard(sv.arcode) then
		e:GetHandler():CompleteProcedure()
	end
end
function sv.fieldop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if c and c:IsCode(sv.field,sv.field+e:GetLabel()) then return end
	local field=Duel.CreateToken(tp,sv.field+e:GetLabel())
	Duel.MoveToField(field,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
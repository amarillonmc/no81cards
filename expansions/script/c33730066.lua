--键★记忆 - 神奈·天地 / Memoria K.E.Y - Kanna -UNIVERSO-
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.incon)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
	--protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--extra protection
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(s.prcon)
	e5:SetValue(s.unval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
	--cannot be material
	local m1=Effect.CreateEffect(c)
	m1:SetType(EFFECT_TYPE_SINGLE)
	m1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	m1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	m1:SetCondition(s.prcon)
	m1:SetValue(s.matlim)
	c:RegisterEffect(m1)
	local m2=m1:Clone()
	m2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(m2)
	local m3=m1:Clone()
	m3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(m3)
	local m4=m1:Clone()
	m4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(m4)
end
s.wind_wb_key_monsters = true

function s.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsFaceup() and c:IsCode(33730060) and c:IsLevel(12)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil,tp)
	e:SetLabelObject(g)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,e:GetHandler():GetControler(),e:GetHandler():GetLocation())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c or not c:IsRelateToEffect(e) then return end
	c:SetMaterial(e:GetLabelObject())
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	c:CompleteProcedure()
end

function s.incon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,c)
	local b2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	local select
	if #b1>0 then
		select=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		if select==0 then
			Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		else
			Duel.Destroy(b1,REASON_COST)
		end
	end
	if #b2>0 then
		select=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
		if select==0 then
			Duel.Damage(tp,2000,REASON_COST)
		else
			Duel.Destroy(b2,REASON_COST)
		end
	end
end

function s.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST)
end
function s.prcon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and #mg>0 and mg:IsExists(s.mfilter,1,nil)
end
function s.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.matlim(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA)
end
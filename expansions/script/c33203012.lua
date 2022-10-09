--霸王缝合僵尸 扎克
function c33203012.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c33203012.fusfilter1,c33203012.fusfilter2,c33203012.fusfilter3,c33203012.fusfilter4)
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c33203012.limval)
	c:RegisterEffect(e2)
	--destroy drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33203012,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c33203012.ddcon)
	e3:SetTarget(c33203012.ddtg)
	e3:SetOperation(c33203012.ddop)
	c:RegisterEffect(e3)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33203012,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c33203012.destg)
	e4:SetOperation(c33203012.desop)
	c:RegisterEffect(e4)
	--Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(aux.indoval)
	c:RegisterEffect(e6)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(33203012,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(c33203012.sptg)
	e7:SetOperation(c33203012.spop)
	c:RegisterEffect(e7)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(33203012,3))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(c33203012.pencon)
	e8:SetTarget(c33203012.pentg)
	e8:SetOperation(c33203012.penop)
	c:RegisterEffect(e8)
end
c33203012.material_type=TYPE_SYNCHRO
function c33203012.fusfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_FUSION)
end
function c33203012.fusfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_SYNCHRO)
end
function c33203012.fusfilter3(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_XYZ)
end
function c33203012.fusfilter4(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_PENDULUM)
end
function c33203012.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c33203012.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c33203012.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c33203012.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c33203012.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33203012.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33203012.ddfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c33203012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33203012.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c33203012.spfilter(c,e,tp)
	return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c33203012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33203012.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c33203012.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33203012.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33203012.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c33203012.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c33203012.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


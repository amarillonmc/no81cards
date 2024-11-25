--石刻龙 大理石
function c51927003.initial_effect(c)
	--Carved stone(earth)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51927003)
	e1:SetCondition(c51927003.spcon)
	e1:SetTarget(c51927003.sptg)
	e1:SetOperation(c51927003.spop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51927004)
	e2:SetCondition(c51927003.nscon)
	e2:SetTarget(c51927003.nstg)
	e2:SetOperation(c51927003.nsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c51927003.condition)
	e4:SetOperation(c51927003.operation)
	c:RegisterEffect(e4)
end
function c51927003.cfilter(c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0x6256) and c:IsFaceup()
end
function c51927003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c51927003.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c51927003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c51927003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c51927003.nscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c51927003.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function c51927003.nsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(51927003,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	Duel.RegisterEffect(e2,tp)
end
function c51927003.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsSummonType(SUMMON_TYPE_ADVANCE) and rc:IsType(TYPE_NORMAL) and c:IsReason(REASON_RELEASE) and rc:IsFaceup()
end
function c51927003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local rc=c:GetReasonCard()
	rc:RegisterFlagEffect(51927003,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51927003,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetAbsoluteRange(ep,LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(rc)
	e1:SetCondition(c51927003.atkcon)
	e1:SetTarget(c51927003.atkfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_PIERCE)
	Duel.RegisterEffect(e2,tp)
end
function c51927003.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local fid=e:GetLabel()
	return rc:GetFlagEffectLabel(51927003)==fid
end
function c51927003.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsType(TYPE_NORMAL)
end

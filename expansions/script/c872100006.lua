--永夜抄·竹林组
local m=872100006
local cm=_G["c"..m]
function c872100006.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba1),aux.NonTuner(Card.IsSetCard,0xba1),1)
---
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c872100006.aclimit)
	c:RegisterEffect(e2)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(872100006,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,872100006)
	e5:SetCondition(c872100006.spcon)
	e5:SetCost(c872100006.spcost)
	e5:SetTarget(c872100006.sptg)
	e5:SetOperation(c872100006.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c872100006.spcon2)
	c:RegisterEffect(e6)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c872100006.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c872100006.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end
---
function c872100006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c872100006.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c872100006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c872100006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c872100006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(800)
		c:RegisterEffect(e1)
	end
end
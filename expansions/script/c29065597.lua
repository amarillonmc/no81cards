--年·众相之柱
function c29065597.initial_effect(c)
	c:SetUniqueOnField(1,0,29065597)
	c:EnableCounterPermit(0x11ae)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),12,12,c29065597.ovfilter,aux.Stringid(29065597,0))
	c:EnableReviveLimit()
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c29065597.effcon)
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065597,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,09065597)
	e2:SetCost(c29065597.icost)
	e2:SetTarget(c29065597.itarget)
	e2:SetOperation(c29065597.ioperation)
	c:RegisterEffect(e2)  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c29065597.lrop)
	c:RegisterEffect(e4)
end
function c29065597.ovfilter(c)
local tp=c:GetControler()
	local x=Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)
	return c:IsFaceup() and not c:IsCode(29065597) and x>=12 and c:IsType(TYPE_XYZ)
end
function c29065597.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c29065597.icost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065597.itarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c29065597.ioperation(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("明王圣帝，何者可去兵哉！")
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c:GetBaseAttack()*2)
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c29065597.xxtg)
	e1:SetValue(c29065597.val)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c29065597.efilter)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87af))
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c29065597.xxtg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x87af)
end
function c29065597.val(e,c)
	return c:GetBaseDefense()*2
end
function c29065597.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c29065597.lrop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then return false end
	Debug.Message("天有洪炉，地生五金，晖冶寒淬照云清！")
	Debug.Message("XYZ召唤！RANK12！年•众相之柱！")
end







--深 底 的 神 之 血
local m=22348244
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22348244.cost)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22348244.condition)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348244,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,22348244)
	e3:SetTarget(c22348244.rectg)
	e3:SetOperation(c22348244.recop)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348244,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c22348244.spcost)
	e4:SetTarget(c22348244.sptg)
	e4:SetOperation(c22348244.spop)
	c:RegisterEffect(e4)
	
end

function c22348244.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c22348244.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22348244.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x709) and c:IsAbleToRemoveAsCost()
end
function c22348244.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and Duel.IsExistingMatchingCard(c22348244.cfilter,tp,LOCATION_MZONE,0,1,nil) then
	if chk==0 then return Duel.IsExistingMatchingCard(c22348244.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,c22348244.cfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if Duel.Remove(rc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c22348244.retop)
		Duel.RegisterEffect(e1,tp)
	end
	else
	if chk==0 then return true end
	end
end
function c22348244.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22348244.recfilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x709) and c:IsType(TYPE_MONSTER)
end
function c22348244.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c22348244.recfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
end
function c22348244.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c22348244.recfilter,p,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if ct>0 then
		Duel.Recover(p,ct*200,REASON_EFFECT)
	end
end
function c22348244.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c22348244.reccfilter(c,e,tp)
	return c:IsSetCard(0x709) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c22348244.thfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function c22348244.thfilter(c,e,tp,code)
	return c:IsSetCard(0x709) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348244.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c22348244.spcost(e,tp,eg,ep,ev,re,r,rp,0)
			and Duel.CheckReleaseGroup(tp,c22348244.reccfilter,1,nil,e,tp) and Duel.CheckLPCost(tp,1000)
	end
	c22348244.spcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.PayLPCost(tp,1000)
	local rg=Duel.SelectReleaseGroup(tp,c22348244.reccfilter,1,1,nil,e,tp)
	e:SetValue(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c22348244.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348244.thfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,e:GetValue())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

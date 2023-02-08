--辉 煌 机 界 神
local m=22348132
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c22348132.filter,1,1,22348031,22348032,22348033,22348034,22348035,22348036)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22348132.sumlimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22348132.efilter)
	c:RegisterEffect(e2)
	--removeself
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348132,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22348132.rscon)
	e3:SetCost(c22348132.rscost)
	e3:SetOperation(c22348132.rsop)
	c:RegisterEffect(e3)
	--dddd
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348132,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c22348132.ddcon)
	e4:SetTarget(c22348132.ddtg)
	e4:SetOperation(c22348132.ddop)
	c:RegisterEffect(e4) 
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	if not c22348132.global_flag then
		c22348132.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22348132.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22348132.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22348030) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22348132,0,0,0)
		elseif tc:IsCode(22348031) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22349132,0,0,0)
		elseif tc:IsCode(22348032) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22350132,0,0,0)
		elseif tc:IsCode(22348033) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22351132,0,0,0)
		elseif tc:IsCode(22348034) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22352132,0,0,0)
		elseif tc:IsCode(22348035) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22353132,0,0,0)
		elseif tc:IsCode(22348036) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22354132,0,0,0)
		end
	end
end
function c22348132.filter(c)
	return c:IsFusionCode(22348030)
end
function c22348132.sumlimit(e,se,sp,st)
	local tp=e:GetHandler():GetControler()
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and
	Duel.GetFlagEffect(tp,22348132)>0 and
	Duel.GetFlagEffect(tp,22349132)>0 and
	Duel.GetFlagEffect(tp,22350132)>0 and
	Duel.GetFlagEffect(tp,22351132)>0 and
	Duel.GetFlagEffect(tp,22352132)>0 and
	Duel.GetFlagEffect(tp,22353132)>0 and
	Duel.GetFlagEffect(tp,22354132)>0
end
function c22348132.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c22348132.rscon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetCurrentPhase()~=PHASE_END
end
function c22348132.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c22348132.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22348132.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22348132.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c22348132.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,22348132))
	e2:SetValue(700)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,22348132))
	e3:SetValue(700)
	Duel.RegisterEffect(e3,tp)
end
function c22348132.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
function c22348132.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c22348132.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22348132.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.TURE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and  Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
			Duel.BreakEffect()
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.TURE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,1,nil) then
			Duel.BreakEffect()
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,nil)
	Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end 
end
end









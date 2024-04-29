--护 灵 天 使  梅 露 司
local m=22348400
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348400,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c22348400.hdcost)
	e1:SetOperation(c22348400.hdop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348400,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c22348400.sumcon)
	e2:SetTarget(c22348400.sumtg)
	e2:SetOperation(c22348400.sumop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c22348400.rectg)
	e3:SetOperation(c22348400.recop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
end
function c22348400.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22348400.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(c22348400.lpcon0)
	e0:SetOperation(c22348400.lpop1)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22348400.lpcon1)
	e1:SetOperation(c22348400.lpop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22348400.regcon)
	e2:SetOperation(c22348400.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c22348400.lpcon2)
	e3:SetOperation(c22348400.lpop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c22348400.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c22348400.lpcon0(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348400.cfilter,1,nil,1-tp)
end
function c22348400.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348400.cfilter,1,nil,1-tp) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c22348400.lpop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end
function c22348400.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348400.cfilter,1,nil,1-tp) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c22348400.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,22348400,RESET_CHAIN,0,1)
end
function c22348400.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22348400)>0
end
function c22348400.lpop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,22348400)
	Duel.ResetFlagEffect(tp,22348400)
	local rnum=n*500
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end
function c22348400.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and 1-tp==rp
end
function c22348400.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348400.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22348400.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1= not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	local b2= Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
	if chk==0 then return (not b1 and not b2 and Duel.IsPlayerCanDraw(tp,1)) or (b1 and not b2 and Duel.IsPlayerCanDraw(tp,2)) or (b2 and not b1 and Duel.IsPlayerCanDraw(tp,2)) or (b1 and b2 and Duel.IsPlayerCanDraw(tp,3)) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function c22348400.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1200,REASON_EFFECT)~=0 then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1 then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c22348400.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c22348400.splimit(e,c)
	return c:IsCode(22348400)
end

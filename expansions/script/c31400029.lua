local m=31400029
local cm=_G["c"..m]
cm.name="精灵媒师 薇茵"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.sumedop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.sumcost)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
end
function cm.sumedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.SetChainLimitTillChainEnd(cm.chainlm)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetOperation(cm.sucop)
	e1a:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1a,tp)
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1b:SetCode(EVENT_CHAIN_END)
	e1b:SetOperation(cm.cedop1)
	e1b:SetReset(RESET_PHASE+PHASE_END)
	e1b:SetLabelObject(e1a)
	Duel.RegisterEffect(e1b,tp)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2a:SetCode(EVENT_SUMMON_SUCCESS)
	e2a:SetOperation(cm.sucop)
	e2a:SetReset(RESET_PHASE+PHASE_END)
	e2a:SetLabel(1)
	Duel.RegisterEffect(e2a,tp)
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2b:SetCode(EVENT_CHAIN_END)
	e2b:SetOperation(cm.cedop2)
	e2b:SetReset(RESET_PHASE+PHASE_END)
	e2b:SetLabelObject(e2a)
	Duel.RegisterEffect(e2b,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.chainop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.sucfilter(c)
	return c:IsSetCard(0xb5)
end
function cm.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.sucfilter,1,nil) then
		e:SetLabel(1)
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	else e:SetLabel(0) end
end
function cm.cedop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	end
end
function cm.cedop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xb5) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.sumcostfilter1(c)
	local tp=c:GetControler()
	return c:IsSetCard(0x20b5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.sumcostfilter2,tp,LOCATION_DECK,0,1,c)
end
function cm.sumcostfilter2(c)
	return c:IsSetCard(0x10b5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsCode(m)
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumcostfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local costg1=Duel.SelectMatchingCard(tp,cm.sumcostfilter1,tp,LOCATION_DECK,0,1,1,nil)
	local costg2=Duel.SelectMatchingCard(tp,cm.sumcostfilter2,tp,LOCATION_DECK,0,1,1,costg1)
	costg1:Merge(costg2)
	Duel.Remove(costg1,POS_FACEUP,REASON_COST)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsSummonable(true,e) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESET_CHAIN,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Summon(tp,c,true,e)
end
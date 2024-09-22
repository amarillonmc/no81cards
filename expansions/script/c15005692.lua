local m=15005692
local cm=_G["c"..m]
cm.name="可那明日终究刺骨"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15005692)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--sum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(cm.sumcost)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
end
function cm.ctfilter(c,ec,tp)
	return c:IsControler(tp) and c:GetFlagEffect(m)==0
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,e:GetHandler(),tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(0x1,1) then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,1,REASON_COST)
end
function cm.sumfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf3f) and c:IsSummonable(true,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
		Duel.Summon(tp,tc,true,nil)
	end
end
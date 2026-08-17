--杀戮行进·乱舞
local m=14000029
local cm=_G["c"..m]
cm.named_with_Marsch=1
function cm.initial_effect(c)
	aux.AddCodeList(c,14000021)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(cm.actcost)
	e1:SetCondition(cm.actcon)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--chain limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(cm.chainop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(14000021,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return (c:IsCode(14000021) or aux.IsCodeListed(c,14000021))
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(14000021,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsCode(14000021) or aux.IsCodeListed(c,14000021))
end
function cm.TM(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Marsch
end
function cm.cfilter(c)
	return c:IsFaceup() and (c:IsCode(14000021) or cm.TM(c))
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if not c:IsAbleToRemove() then return end
	if rc:IsCode(14000021) or cm.TM(rc) then
		Duel.SetChainLimit(cm.chainlm)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
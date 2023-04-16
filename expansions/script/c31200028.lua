--机骸少女·锯锹
local m=31200028
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter,2,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsFusionSetCard(0x3a0)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x3a0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or (c:IsSSetable() and not c:IsType(TYPE_FIELD) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (c:IsSSetable() and c:IsType(TYPE_FIELD) and not Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)))
end
function cm.thfilter1(c)
	return not c:IsType(TYPE_MONSTER) and c:GetSequence()>4
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local a=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsSSetable() and not Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_ONFIELD,0,1,nil) and tc:IsType(TYPE_FIELD) then a=a+1 end
	if tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsType(TYPE_FIELD) then a=a+1 end
	if g:GetCount()>0 and a>0 and Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==1 then
	Duel.SSet(tp,g,tp,false)
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
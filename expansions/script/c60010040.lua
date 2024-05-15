--白银之城的纤茶壶
local cm,m,o=GetID()
function cm.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+10000000)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to hand or spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tscon)
	e2:SetTarget(cm.tstg)
	e2:SetOperation(cm.tsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(cm.thcon)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x17e) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local gg=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #gg>0 then
		Duel.HintSelection(gg)
		if Duel.ChangePosition(gg,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SSet(tp,g:GetFirst())
			end
		end
	end
end

function cm.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and r&REASON_COST>0
		and (rc:IsSetCard(0x17e) and not rc:IsCode(m) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:GetType()==TYPE_TRAP)
		and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) and not eg:IsContains(e:GetHandler())
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and rp==tp and re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetOriginalType()==TYPE_TRAP
		and eg:IsExists(cm.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function cm.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function cm.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if aux.NecroValleyNegateCheck(c) then return end
	if not aux.NecroValleyFilter()(c) then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if op==2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
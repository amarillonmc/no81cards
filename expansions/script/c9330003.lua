--陷阵营统帅
function c9330003.initial_effect(c)
	aux.AddCodeList(c,9330001)
	aux.AddMaterialCodeList(c,9330001)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,9330001),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,9330001,LOCATION_ONFIELD+LOCATION_GRAVE)
   --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9330003.splimit)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9330003.efilter)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9330003,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c9330003.actcon)
	e3:SetTarget(c9330003.distg)
	e3:SetOperation(c9330003.actop)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c9330003.effcon)
	e4:SetOperation(c9330003.effop)
	c:RegisterEffect(e4)
end
function c9330003.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or 
		   (bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO and (not se or not se:IsHasType(EFFECT_TYPE_ACTIONS)))
end
function c9330003.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and not te:GetOwner():IsSetCard(0xaf93)
end
function c9330003.filter1(e,c)
	return c:IsSetCard(0xaf93) and not c:IsCode(9330001)
end
function c9330003.efilter2(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9330003.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLevelAbove(7)
end
function c9330003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9330003.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or c:IsLevelBelow(6) then return end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330003,0))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-3)
	c:RegisterEffect(e1)
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0
		and tc:IsType(TYPE_TRAP)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and tc:IsLocation(LOCATION_REMOVED)
		and tc:IsSSetable()
		and Duel.SelectYesNo(tp,aux.Stringid(9330003,1)) then
		Duel.BreakEffect()
		Duel.SSet(tp,tc)
	end
end
function c9330003.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_RITUAL)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():GetReasonCard():IsSetCard(0xaf93)
end
function c9330003.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9330003,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9330003.actcon)
	e1:SetTarget(c9330003.distg)
	e1:SetOperation(c9330003.actop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end

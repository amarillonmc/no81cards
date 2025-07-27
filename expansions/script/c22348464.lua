--墓园死者 衔魂拟兽
local m=22348464
local cm=_G["c"..m]
function cm.initial_effect(c)
	--atkdown
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22348464,0))
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,22348464)
	e0:SetCost(c22348464.cost)
	e0:SetTarget(c22348464.target)
	e0:SetOperation(c22348464.operation)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348464,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22348464)
	e1:SetCost(c22348464.spcost)
	e1:SetTarget(c22348464.sptg)
	e1:SetOperation(c22348464.spop)
	c:RegisterEffect(e1)
end
function c22348464.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(22348464)~=0 then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348464.cfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetFlagEffectLabel(22348464)~=0
end
function c22348464.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c22348464.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(c22348464.cfilter,nil)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c22348464.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22348464.atkfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c22348464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	local tep=nil
	if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
	if tep and tep==1-tp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c22348464.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1 and tc2 and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		tc1:SetCardTarget(tc2)
		tc1:RegisterFlagEffect(22348464,RESET_EVENT+RESETS_STANDARD,0,1,1)
		tc2:RegisterFlagEffect(22348464,RESET_EVENT+RESETS_STANDARD,0,1,1)
	--tg
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e01:SetCode(EVENT_LEAVE_FIELD_P)
	e01:SetOperation(c22348464.checkop)
	tc1:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e02:SetCode(EVENT_LEAVE_FIELD)
	e02:SetCondition(c22348464.descon)
	e02:SetOperation(c22348464.desop)
	e02:SetLabelObject(e01)
	tc1:RegisterEffect(e02)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_LEAVE_FIELD_P)
	e11:SetOperation(c22348464.checkop)
	tc2:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_LEAVE_FIELD)
	e12:SetCondition(c22348464.descon)
	e12:SetOperation(c22348464.desop)
	e12:SetLabelObject(e11)
	tc2:RegisterEffect(e12)
		if e:GetLabel()==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c22348464.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetValue(c22348464.efilter)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e2)
		end
	end
end
function c22348464.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() or not te:GetOwner():GetFlagEffectLabel(22348464)~=0
end
function c22348464.spcostfilter(c,tp)
	return c:IsSetCard(0x703) and c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c22348464.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348464.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348464.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348464.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348464.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end




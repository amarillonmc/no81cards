--惧 轮 狂 突 猛 进
function c53701011.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53701011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_MSET+TIMING_SSET+TIMING_FLIPSUMMON+TIMING_EQUIP)
	e1:SetCondition(c53701011.condition)
	e1:SetCost(c53701011.cost)
	e1:SetTarget(c53701011.target)
	e1:SetOperation(c53701011.operation)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53701011,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c53701011.descon)
	e3:SetTarget(c53701011.destg)
	e3:SetOperation(c53701011.desop)
	c:RegisterEffect(e3)
end
function c53701011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c53701011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.GetFlagEffect(tp,53701011)==0 end
	Duel.PayLPCost(tp,1000)
	Duel.RegisterFlagEffect(tp,53701011,RESET_CHAIN,0,1)
end
function c53701011.filter(c,e,sp)
	return c:IsSetCard(0x3530) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c53701011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53701011.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c53701011.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c53701011.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(53701011,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c53701011.thcon)
		e3:SetOperation(c53701011.thop)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.SpecialSummonComplete()
end
function c53701011.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(53701011)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c53701011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c53701011.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x3530)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c53701011.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53701011.cfilter,1,nil,tp)
end
function c53701011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c53701011.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
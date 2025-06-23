--人理之基 赵子龙
local s,id,o=GetID()
function c22023530.initial_effect(c)
	--get control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023530,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,22023531)
	e1:SetCost(c22023530.cost1)
	e1:SetTarget(c22023530.contrtg)
	e1:SetOperation(c22023530.controp)
	c:RegisterEffect(e1)
	--banish temporary
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023530,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(7,22023530+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c22023530.cost)
	e2:SetTarget(c22023530.rmtg)
	e2:SetOperation(c22023530.rmop)
	c:RegisterEffect(e2)
end
function c22023530.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c22023530.contrfilter(c,tp)
	return c:GetOwner()==tp and c:IsControlerCanBeChanged()
end
function c22023530.contrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22023530.contrfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22023530.contrfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c22023530.contrfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c22023530.controp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and Duel.GetControl(tc,tp) and tc:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22023530,3)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22023530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22023531)==0 end
	Duel.RegisterFlagEffect(tp,22023531,RESET_CHAIN,0,1)
end
function c22023530.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c22023530.exfilter(c)
	return c:IsAbleToGrave(TYPE_FUSION)
end
function c22023530.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c22023530.retop)
			Duel.RegisterEffect(e1,tp)
		end
		if Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(c22023530.exfilter,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(22023530,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c22023530.exfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c22023530.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

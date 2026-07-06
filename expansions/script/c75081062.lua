--罪秽的骑士 古斯塔夫
function c75081062.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081062,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75081062)
	--e1:SetCondition(c75081062.con1)
	e1:SetCost(c75081062.cost1)
	e1:SetTarget(c75081062.thtg)
	e1:SetOperation(c75081062.thop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081062,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,75081062)
	--e2:SetCondition(c75081062.con1)
	e2:SetCost(c75081062.cost2)
	e2:SetTarget(c75081062.thtg)
	e2:SetOperation(c75081062.thop)
	c:RegisterEffect(e2) 
end
function c75081062.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081062 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c75081062.retop)
		Duel.RegisterEffect(e1,tp)
	end
end

function c75081062.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if Duel.ReturnToField(tc)~=0 and Duel.GetFlagEffect(tp,75081065)==0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
		Duel.RegisterFlagEffect(tp,75081065,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e2)
	end
end
--
function c75081062.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081062 then
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(c75081062.retcon1)
		e1:SetOperation(c75081062.retop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(75081062,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
end
function c75081062.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081062)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081062.rmfilter(c)
	return c:IsSetCard(0x75c) and c:IsAbleToGrave()
end
function c75081062.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c75081062.rmfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,75081063)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081062,2)) then
		Duel.RegisterFlagEffect(tp,75081063,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c75081062.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
--
function c75081062.thfilter(c)
	return c:IsSetCard(0x75c) and c:IsAbleToHand()
end
function c75081062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75081062.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c75081062.drcon1)
	e1:SetOperation(c75081062.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75081062.filter(c,tp)
	return c:IsSetCard(0x75c) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c75081062.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081062.filter,1,nil,tp)
		--and not Duel.IsChainSolving()
end
function c75081062.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.HintSelection(g)
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(75081064,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetCondition(c75081062.retcon2)
			e1:SetOperation(c75081062.retop2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c75081062.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(75081064)~=0
end
function c75081062.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
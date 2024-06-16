--雪狱之罪流 罔两遗珠
function c9911388.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc956),4,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911388,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e1:SetCondition(c9911388.imcon)
	e1:SetOperation(c9911388.imop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911388,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9911388.thtg)
	e2:SetOperation(c9911388.thop)
	c:RegisterEffect(e2)
	if not c9911388.global_check then
		c9911388.global_check=true
		c9911388[0]=0
		c9911388[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c9911388.clearop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911388.clearop(e,tp,eg,ep,ev,re,r,rp)
	c9911388[0]=0
	c9911388[1]=0
end
function c9911388.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and e:GetHandler():GetOverlayCount()>0 and Duel.GetFlagEffect(tp,9911388)==0
end
function c9911388.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(9911388,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	Duel.RegisterFlagEffect(tp,9911388,RESET_PHASE+PHASE_END,0,1)
	Duel.ResetFlagEffect(tp,9911389)
	Duel.ResetFlagEffect(tp,9911390)
	c9911388[tp]=c9911388[tp]+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9911388.imcon2)
	e1:SetOperation(c9911388.imop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(c9911388[tp])
	Duel.RegisterEffect(e1,tp)
end
function c9911388.imcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActivated() and Duel.GetFlagEffect(tp,9911389)==0 and Duel.GetFlagEffect(tp,9911390)==0
		and e:GetLabel()==c9911388[tp]
end
function c9911388.imop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,9911389,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(c9911388.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(re)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c9911388.matcon)
	e2:SetOperation(c9911388.matop)
	e2:SetLabelObject(re)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetCondition(c9911388.matcon)
	e3:SetOperation(c9911388.resetop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(re)
	Duel.RegisterEffect(e3,tp)
end
function c9911388.efilter(e,te)
	return te==e:GetLabelObject()
end
function c9911388.matcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9911388.matop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9911390)==0 then Duel.RegisterFlagEffect(tp,9911390,RESET_PHASE+PHASE_END,0,1) end
	if not (re and e:GetLabelObject() and re==e:GetLabelObject()) then return end
	Duel.Hint(HINT_CARD,0,9911388)
	local c=e:GetHandler()
	if c:GetFlagEffect(9911388)~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(9911388,2))
	Duel.ResetFlagEffect(tp,9911388)
end
function c9911388.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,9911389)
	if re and e:GetLabelObject() and re==e:GetLabelObject() and Duel.GetFlagEffect(tp,9911390)~=0 then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(9911388,2))
		Duel.ResetFlagEffect(tp,9911388)
	end
end
function c9911388.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9911388.thop(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,1,cl,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		for tc in aux.Next(sg) do
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

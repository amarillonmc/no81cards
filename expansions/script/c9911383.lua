--雪狱之罪证 紧锁的真实
function c9911383.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsPublic))
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e3:SetCondition(c9911383.gravecon)
	e3:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9911383)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c9911383.distg)
	e4:SetOperation(c9911383.disop)
	c:RegisterEffect(e4)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911384)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911383.rmcon)
	e2:SetCost(c9911383.rmcost)
	e2:SetTarget(c9911383.rmtg)
	e2:SetOperation(c9911383.rmop)
	c:RegisterEffect(e2)
end
function c9911383.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function c9911383.tdfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc956)
end
function c9911383.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9911383.tdfilter1,tp,LOCATION_REMOVED,0,2,nil)
		and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911383,0))
	local g1=Duel.SelectTarget(tp,c9911383.tdfilter1,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g2=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
end
function c9911383.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and g:IsContains(tc) and tc:IsControler(1-tp) and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
	local fid=c:GetFieldID()
	local sc=g:GetFirst()
	while sc do
		sc:RegisterFlagEffect(9911383,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		sc=g:GetNext()
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c9911383.tdcon)
	e1:SetOperation(c9911383.tdop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,9911384,RESET_PHASE+PHASE_END,0,1)
end
function c9911383.tdfilter2(c,fid)
	return c:GetFlagEffectLabel(9911383)==fid and c:IsAbleToDeck()
end
function c9911383.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c9911383.tdfilter2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9911383.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c9911383.tdfilter2,nil,e:GetLabel())
	g:DeleteGroup()
	if #sg>0 then
		Duel.Hint(HINT_CARD,0,9911383)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c9911383.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911384)==0
end
function c9911383.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911383.rmfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemove()
end
function c9911383.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911383.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9911383.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9911383.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			if Duel.GetCurrentPhase()==PHASE_STANDBY then
				e1:SetLabel(Duel.GetTurnCount())
				e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
				tc:RegisterFlagEffect(9911385,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2)
			else
				e1:SetLabel(0)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY)
				tc:RegisterFlagEffect(9911385,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1)
			end
			e1:SetCondition(c9911383.retcon)
			e1:SetOperation(c9911383.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9911383.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(9911385)~=0 and Duel.GetTurnCount()~=e:GetLabel()
end
function c9911383.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

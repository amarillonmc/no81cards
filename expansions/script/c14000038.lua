--悖论少女
local m=14000038
local cm=_G["c"..m]
function cm.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(14000021)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.setcon1)
	e3:SetOperation(cm.setop1)
	c:RegisterEffect(e3)
end
function cm.TM(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Marsch
end
function cm.disfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function cm.disfilter1(c)
	return cm.TM(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable() and c:IsSSetable()
end
function cm.setfilter(c)
	return cm.TM(c) and c:IsSSetable()
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.setfilter,tp,LOCATION_GRAVE,0,nil)
	local ct1=Duel.GetMatchingGroupCount(cm.disfilter1,tp,LOCATION_HAND,0,nil)
	ct=ct+ct1
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_HAND,0,1,math.min(ct,ft),nil)
	if #g>0 then
		local ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_GRAVE,0,ct,ct,nil,tp)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SSet(tp,g)
			end
		end
	end
end
function cm.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.setop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.scon)
	e1:SetOperation(cm.sop)
	Duel.RegisterEffect(e1,tp)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFieldGroupCount(ep,LOCATION_DECK,0)>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.ConfirmDecktop(ep,1)
		local g=Duel.GetDecktopGroup(ep,1)
		local tc=g:GetFirst()
		if tc and tc:IsType(TYPE_QUICKPLAY) and tc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.DisableShuffleCheck()
			Duel.SSet(tp,tc)
			if cm.TM(tc) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
local m=4878139
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.lvtg)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end
function cm.atktg(e,c)
	return c:IsSetCard(0x48c,0x48f)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+3)<1
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)<1
end
function cm.target(e,c)
	return c:IsSetCard(0x48c)
end
function cm.lvfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x48c)
end
function cm.filter(c)
	return c:IsSetCard(0x48f) and c:IsSSetable() and c:IsType(TYPE_TRAP)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.lvfilter(chkc) end
	if chk==0 then return c:GetFlagEffect(m+2)==0 and Duel.IsExistingTarget(cm.lvfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
   Duel.SelectTarget(tp,cm.lvfilter,tp,LOCATION_GRAVE,0,1,1,nil)
   Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
   c:RegisterFlagEffect(m+1,RESET_CHAIN,0,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
	end
	end
end
function cm.filter2(c,g)
	return g:IsContains(c) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) and c:GetFlagEffect(m+2)==0  end
   Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	 if Duel.IsPlayerAffectedByEffect(tp,4878130) then
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
   end
   c:RegisterFlagEffect(m+2,RESET_CHAIN,0,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
   local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	if g:GetCount()>0 then
			 Duel.HintSelection(g)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		e:GetHandler():RegisterFlagEffect(m+3,RESET_PHASE+PHASE_END,0,1)
		  if Duel.IsPlayerAffectedByEffect(tp,4878130) then
	Duel.Draw(tp,1,REASON_EFFECT)
   end
end
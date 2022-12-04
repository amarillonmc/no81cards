local m=53739008
local cm=_G["c"..m]
cm.name="生命的异金"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup() and ((c:IsCanTurnSet() and c:GetBaseAttack()<=1000) or (c:IsAbleToHand() and c:GetBaseAttack()>1000))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetFirst():GetBaseAttack()<=1000 then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0) end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		if tc:GetBaseAttack()<=1000 then
			if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then Duel.Destroy(tc,REASON_EFFECT) end
		else
			if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
				local p=tc:GetPreviousControler()
				if Duel.GetLocationCount(p,LOCATION_MZONE,p)>0 and Duel.IsExistingMatchingCard(cm.spfilter,p,LOCATION_HAND,0,1,nil,e,p) and Duel.SelectYesNo(p,aux.Stringid(m,3)) then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
					local g=Duel.SelectMatchingCard(p,cm.spfilter,p,LOCATION_HAND,0,1,1,nil,e,p)
					Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
					Duel.ConfirmCards(1-p,g)
				end
			end
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function cm.desfilter(c,tc)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then return tc:IsSSetable(true) else return tc:IsSSetable() end
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetLabel()==0 and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	local b1=Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,nil) and Duel.GetFlagEffect(tp,m)==0
	local b2=e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.GetFlagEffect(tp,m+50)==0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and b2 then s=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then s=Duel.SelectOption(tp,aux.Stringid(m,1)) else s=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
	e:SetLabel(s)
	if s==0 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_REMOVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,1-tp,LOCATION_GRAVE)
	end
	if s==1 then
		e:SetProperty(EFFECT_FLAG_DELAY)
		Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if e:GetLabel()==1 then
		if e:GetHandler():IsRelateToEffect(e) then Duel.SSet(tp,e:GetHandler()) end
	end
end

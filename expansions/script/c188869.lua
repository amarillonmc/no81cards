local m=188869
local cm=_G["c"..m]
cm.name="神意之王女-云岚"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xcac),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.rttg)
	e1:SetOperation(cm.rtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0xcac) and c:IsFaceup()
end
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=math.abs(c:GetLevel()-c:GetOriginalLevel())
	if chk==0 then return ct~=0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.abs(c:GetLevel()-c:GetOriginalLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,ct,ct,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=Duel.GetOperatedGroup()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(c:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local rg=og:Filter(function(c)return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()end,nil)
		if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=rg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:GetLevel()>0 end,tp,LOCATION_MZONE,0,nil)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and e:GetHandler():IsAbleToExtra() and g and g:GetSum(Card.GetLevel)%2==0 and Duel.GetMatchingGroupCount(function(c)return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsSetCard(0xcac)end,tp,LOCATION_ONFIELD,0,nil)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.NegateActivation(ev) then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end

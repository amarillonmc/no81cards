--编码-零 关键节点
local m=14000613
local cm=_G["c"..m]
cm.named_with_CodeNull=1
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.eccost)
	e1:SetCondition(cm.eccon)
	e1:SetTarget(cm.ectg)
	e1:SetOperation(cm.ecop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.tgcost)
	e2:SetCondition(cm.tgcon1)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(cm.tgcon2)
	c:RegisterEffect(e3)
end
function cm.Code0(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CodeNull
end
function cm.eccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.eccon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and ((re:GetHandler():IsRace(RACE_CYBERSE) and rp==tp) or Duel.IsPlayerAffectedByEffect(tp,14000608))
end
function cm.ectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=tp
	if rp then
		p=rp
	end
	if chk==0 then return Duel.IsPlayerCanSummon(p) and Duel.IsPlayerCanAdditionalSummon(p) and Duel.GetFlagEffect(p,m)==0 end
end
function cm.ecop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.tgfilter(c,e,tp)
	return c:IsFaceup() and ((c:IsControler(tp) and c:IsRace(RACE_CYBERSE)) or Duel.IsPlayerAffectedByEffect(tp,14000601)) and Duel.IsExistingMatchingCard(cm.tgfilter1,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.tgfilter1(c,code)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToGrave() and not c:IsCode(code)
end
function cm.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,14000601)
end
function cm.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,14000601)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if #g>0 then
		local tc1=g:GetFirst()
		if Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_GRAVE) and tc1:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsAbleToGrave() and aux.NecroValleyFilter()(tc1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsAbleToGrave() then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
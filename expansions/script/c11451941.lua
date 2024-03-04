--虚诞衍律『宫』
local cm,m=GetID()
function cm.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--ritual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.adcon2)
	e2:SetTarget(cm.adtg2)
	e2:SetOperation(cm.adop2)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsPreviousPosition(POS_FACEDOWN)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanTurnSet() and (not tp or c:IsControler(tp))
end
function cm.sfilter(c,e,tp)
	return (not e or c:IsRelateToEffect(e)) and (cm.dfilter(c,tp) or c:GetColumnGroup():IsExists(cm.dfilter,1,c))
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.sfilter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.sfilter,nil,e,tp)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		g=g:Select(tp,1,1,nil)
	end
	if #g>0 then
		Duel.HintSelection(g)
		local sg=g:GetFirst():GetColumnGroup():Filter(cm.dfilter,c)
		g:Merge(sg)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.filter,1,nil,tp,se)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end --c:IsAbleToHand() and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),2,PLAYER_ALL,LOCATION_ONFIELD+c:GetLocation())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local rg=Group.FromCards(c,tc)
	if Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
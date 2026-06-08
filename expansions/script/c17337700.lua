--合辛的商业会长
function c17337700.initial_effect(c)
	--material redirect-hoshin
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_HAND)
	e0:SetCondition(c17337700.redcon)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337700,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17337700)
	e1:SetCondition(c17337700.icon)
	e1:SetCost(c17337700.thcost)
	e1:SetTarget(c17337700.thtg)
	e1:SetOperation(c17337700.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c17337700.qcon)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17337700,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,17337700+1)
	e2:SetCondition(c17337700.setcon)
	e2:SetTarget(c17337700.settg)
	e2:SetOperation(c17337700.setop)
	c:RegisterEffect(e2)
end
function c17337700.redcon(e)
	local c=e:GetHandler()
	return c:IsOnField() and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
function c17337700.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51))
end
function c17337700.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51)
end
function c17337700.costfilter(c,tp)
	return c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(c17337700.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetType()&0x7)
end
function c17337700.thfilter(c,type)
	return c:IsSetCard(0x3f51) and not c:IsType(type) and c:IsAbleToHand()
end
function c17337700.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337700.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337700.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetType()&0x7)
	Duel.HintSelection(Group.FromCards(tc))
	if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c17337700.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17337700.thop(e,tp,eg,ep,ev,re,r,rp)
	local type=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17337700.thfilter,tp,LOCATION_DECK,0,1,1,nil,type)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17337700.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function c17337700.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17337700.chkfilter,1,nil,tp)
end
function c17337700.setfilter(c,tp)
	return c:IsSetCard(0x3f51) and c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or not c:IsForbidden() and c:CheckUniqueOnField(tp))--not c:IsLocation(LOCATION_HAND) and 
end
function c17337700.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17337700.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.IsExistingMatchingCard(c17337700.setfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(17337700,1))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c17337700.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc:IsLocation(LOCATION_HAND) and tc:IsAbleToHand() and (tc:IsForbidden() or not tc:CheckUniqueOnField(tp) or Duel.SelectOption(tp,1190,aux.Stringid(17337700,2))==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end

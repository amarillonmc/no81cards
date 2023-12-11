--雪狱之罪人 不咎
function c9911355.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911355)
	e1:SetTarget(c9911355.sptg)
	e1:SetOperation(c9911355.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911356)
	e2:SetCondition(c9911355.thcon)
	e2:SetCost(c9911355.thcost)
	e2:SetTarget(c9911355.thtg)
	e2:SetOperation(c9911355.thop)
	c:RegisterEffect(e2)
end
function c9911355.filter(c)
	return c:IsFaceupEx() and c:IsAttribute(ATTRIBUTE_WATER) and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c9911355.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9911355.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c9911355.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c9911355.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc:IsSetCard(0xc956) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.max(tc:GetAttack(),tc:GetDefense()))
end
function c9911355.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9911355.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e)
		and Duel.Recover(tp,math.max(tc:GetAttack(),tc:GetDefense()),REASON_EFFECT)>0 and e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(c9911355.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9911355,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if sc and Duel.Remove(sc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				sc:RegisterFlagEffect(9911355,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(sc)
				e1:SetCountLimit(1)
				e1:SetCondition(c9911355.retcon)
				e1:SetOperation(c9911355.retop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c9911355.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(9911355)~=0
end
function c9911355.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local loc=tc:GetPreviousLocation()
	if loc==LOCATION_MZONE then
		Duel.ReturnToField(tc)
	end
	if loc==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c9911355.thcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (LOCATION_GRAVE+LOCATION_REMOVED)&loc~=0
end
function c9911355.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9911355.repop)
end
function c9911355.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(c9911355.indct)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(9911355,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9911355.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c9911355.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xc956) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(9911355)
end
function c9911355.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911355.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c9911355.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911355.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

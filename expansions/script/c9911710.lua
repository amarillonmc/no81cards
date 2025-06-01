--君临河山之剑域
function c9911710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9911710.target)
	c:RegisterEffect(e1)
	if not c9911710.global_check then
		c9911710.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911710.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9911710.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911710.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911710.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9911710.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911710.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9911705)==0
end
function c9911710.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9957) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9911710.cfilter(c,e)
	return c:IsFaceup() and (c:IsAbleToGrave() or c:GetColumnGroup():IsExists(Card.IsAbleToGrave,1,e:GetHandler()))
		 and c:IsCanBeEffectTarget(e)
end
function c9911710.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c9911710.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chkc then return false end
	local b1=(Duel.GetFlagEffect(tp,9911710)==0 or not e:IsCostChecked()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911710.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=(Duel.GetFlagEffect(tp,9911711)==0 or not e:IsCostChecked()) and #g>0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911710,0)},{b2,aux.Stringid(9911710,1)})
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,9911710,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetOperation(c9911710.activate1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOGRAVE)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.RegisterFlagEffect(tp,9911711,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetOperation(c9911710.activate2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:SelectSubGroup(tp,aux.drccheck,false,1,#g)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
	end
end
function c9911710.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911710.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911710,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCondition(c9911710.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c9911710.actcon(e)
	return e:GetHandler():GetFlagEffect(9911705)==0
end
function c9911710.filter(c,i)
	return c:IsRelateToChain() and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and aux.GetColumn(c)==i
end
function c9911710.tgfilter(c,col)
	return bit.band(col,2^aux.GetColumn(c))~=0 and c:IsAbleToGrave()
end
function c9911710.tgfilter2(g)
	for c in aux.Next(g) do
		local cg=Group.__band(c:GetColumnGroup(),g)
		if cg:GetCount()>0 then return false end
	end
	return true
end
function c9911710.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g==0 then return end
	local ct=0
	local col=0
	for i=0,4 do
		if g:IsExists(c9911710.filter,1,nil,i) then
			ct=ct+1
			col=col+2^i
		end
	end
	local tg=Duel.GetMatchingGroup(c9911710.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),col)
	if #tg<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=tg:SelectSubGroup(tp,c9911710.tgfilter2,false,ct,ct)
	if not sg or #sg~=ct then return end
	Duel.HintSelection(sg)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end

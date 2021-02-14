--PSY骨架装备·ζ
function c30002020.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c30002020.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30002020,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c30002020.condition)
	e2:SetTarget(c30002020.target)
	e2:SetOperation(c30002020.operation)
	c:RegisterEffect(e2)
end
function c30002020.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c30002020.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,8802510))
		and rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c30002020.thfilter(c,tp)
	local res=false
	if c:IsType(TYPE_FIELD) then res=c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true)
	elseif c:GetType()==0x20004 then res=c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp)
	elseif c:IsType(TYPE_TRAP) then res=c:IsAbleToHand() end
	return c:IsSetCard(0xc1) and res
end
function c30002020.spfilter(c,e,tp)
	return c:IsCode(49036338) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30002020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c30002020.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c30002020.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30002020.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c30002020.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsType(TYPE_FIELD) and tc:GetActivateEffect():IsActivatable(tp,true,true)
		local b3=tc:GetType()==0x20004 and tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not (b2 or b3) or Duel.SelectOption(tp,1190,1150)==0) then
			if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end
			Duel.ConfirmCards(1-tp,tc)
		elseif b2 then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			if not Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then return end
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c30002020.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	tc:RegisterFlagEffect(30002020,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	c:RegisterFlagEffect(30002020,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	Duel.SpecialSummonComplete()
	g:AddCard(c)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c30002020.rmcon)
	e1:SetOperation(c30002020.rmop)
	Duel.RegisterEffect(e1,tp)
end
function c30002020.rmfilter(c,fid)
	return c:GetFlagEffectLabel(30002020)==fid
end
function c30002020.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c30002020.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c30002020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c30002020.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end

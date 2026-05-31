--囚徒的绝命
function c71280045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71280045,0))
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_DESTROY|CATEGORY_DRAW|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c71280045.target)
	e1:SetOperation(c71280045.activate)
	c:RegisterEffect(e1)
	--Frenzy Captive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71280045,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,71280045)
	e3:SetTarget(c71280045.fctg)
	e3:SetOperation(c71280045.fcop)
	c:RegisterEffect(e3)
end
function c71280045.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x8911) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71280045.desfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x8911) and c:IsType(TYPE_MONSTER)
end
function c71280045.spfilter(c,e,tp)
	return c:IsSetCard(0x8911) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c71280045.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=(Duel.GetFlagEffect(tp,11280045)==0 or not e:IsCostChecked()) 
		and Duel.IsExistingMatchingCard(c71280045.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local b2=(Duel.GetFlagEffect(tp,21280045)==0 or not e:IsCostChecked()) 
		and Duel.IsExistingMatchingCard(c71280045.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2)
	local b3=(Duel.GetFlagEffect(tp,31280045)==0 or not e:IsCostChecked()) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71280045.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(71280045,1),1},
		{b2,aux.Stringid(71280045,2),2},
		{b3,aux.Stringid(71280045,3),3})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,11280045,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,21280045,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	elseif op==3 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
			Duel.RegisterFlagEffect(tp,31280045,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function c71280045.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280045.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c71280045.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	elseif op==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280045.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--cannot atk directly this turn
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c71280045.fcfilter(c,e)
	return c:IsSetCard(0x8911) and c:IsDestructable(e)
end
function c71280045.fctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c71280045.fcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c71280045.fcfilter,nil,e)>0
		and Duel.SelectYesNo(tp,aux.Stringid(71280045,4)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:FilterSelect(tp,c71280045.fcfilter,1,1,nil,e)
		Duel.Destroy(sg,REASON_EFFECT)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
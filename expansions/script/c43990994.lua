--默墟天使之殇
function c43990994.initial_effect(c)
	aux.AddCodeList(c,43990999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990994.target)
	e1:SetOperation(c43990994.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990994,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c43990994.cpcon)
	e2:SetCost(c43990994.cpcost)
	e2:SetTarget(c43990994.cptg)
	e2:SetOperation(c43990994.cpop)
	c:RegisterEffect(e2)
	--counter
	Duel.AddCustomActivityCounter(43990994,ACTIVITY_CHAIN,c43990994.chainfilter)
end
function c43990994.chainfilter(re,tp,cid)
	return re:GetHandler():IsCode(43990999)
end
function c43990994.spfilter(c,e,tp,chk)
	return c:IsCode(43990999) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 and c:IsFaceupEx() or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c43990994.cfilter(c)
	return c:IsCode(43990999) and c:IsFaceup()
end
function c43990994.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c43990994.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,0) and (Duel.GetFlagEffect(tp,43990994)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(c43990994.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and (Duel.GetFlagEffect(tp,43990994-10)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990994,0)},
		{b2,aux.Stringid(43990994,1)})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,43990994,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp)
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
		if e:IsCostChecked() then
			e:SetCategory(0)
			Duel.RegisterFlagEffect(tp,43990994-10,RESET_PHASE+PHASE_END,0,1)
		end
	end
	--
	if e:IsCostChecked() then
		local ct=Duel.GetFlagEffectLabel(tp,43990994) or 0
		ct=ct|op
		if ct==op then
			Duel.RegisterFlagEffect(tp,43990994,RESET_PHASE+PHASE_END,0,1,ct)
		else
			Duel.SetFlagEffectLabel(tp,43990994,ct)
		end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+43990999,e,0,tp,0,0)
	end
end
function c43990994.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c43990994.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,1)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c43990994.distg1)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c43990994.discon)
		e2:SetOperation(c43990994.disop)
		e2:SetLabel(ac)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c43990994.distg2)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c43990994.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c43990994.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c43990994.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c43990994.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c43990994.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9510) and re:IsActiveType(TYPE_MONSTER)
end
function c43990994.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990994.cpfilter(c)
	return c:IsSetCard(0x9510) and c:IsFaceupEx() and c:CheckActivateEffect(false,true,false)~=nil
end
function c43990994.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990994.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
end
function c43990994.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c43990994.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		--Duel.ConfirmCards(1-tp,tc)
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end

--默墟天使·终末逆转
function c43990991.initial_effect(c)
	aux.AddCodeList(c,43990999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990991.target)
	e1:SetOperation(c43990991.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990991,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c43990991.drcon)
	e2:SetCost(c43990991.drcost)
	e2:SetTarget(c43990991.drtg)
	e2:SetOperation(c43990991.drop)
	c:RegisterEffect(e2)
	--counter
	Duel.AddCustomActivityCounter(43990991,ACTIVITY_CHAIN,c43990991.chainfilter)
end
function c43990991.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(43990998)
end
function c43990991.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x9510) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c43990991.cfilter(c)
	return c:IsCode(43990999) and c:IsFaceup()
end
function c43990991.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c43990991.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,0) and Duel.GetMZoneCount(tp)>0 and (Duel.GetFlagEffect(tp,43990991)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(c43990991.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and (Duel.GetFlagEffect(tp,43990991-10)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990991,0)},
		{b2,aux.Stringid(43990991,1)})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,43990991,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(0)
			Duel.RegisterFlagEffect(tp,43990991-10,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetChainLimit(c43990991.chlimit)
	end
	--
	if e:IsCostChecked() then
		local ct=Duel.GetFlagEffectLabel(tp,43990991) or 0
		ct=ct|op
		if ct==op then
			Duel.RegisterFlagEffect(tp,43990991,RESET_PHASE+PHASE_END,0,1,ct)
		else
			Duel.SetFlagEffectLabel(tp,43990991,ct)
		end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+43990999,e,0,tp,0,0)
	end
end
function c43990991.chlimit(e,ep,tp)
	return tp==ep
end
function c43990991.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		local ct=not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>=2 and (Duel.GetCustomActivityCount(43990991,0,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(43990991,1,ACTIVITY_CHAIN)>0) and 2 or 1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c43990991.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil,e,tp,1)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local ct=Duel.GetTurnPlayer()==1-tp and 2 or 1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9510))
		e1:SetValue(c43990991.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9510))
		e2:SetValue(c43990991.sumlimit)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		Duel.RegisterEffect(e3,tp)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		Duel.RegisterEffect(e4,tp)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		Duel.RegisterEffect(e5,tp)
	end
end
function c43990991.efilter(e,re)
	return re and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x9510)
end
function c43990991.sumlimit(e,c,sumtype)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) and (e:GetCode()~=EFFECT_CANNOT_BE_FUSION_MATERIAL or sumtype==SUMMON_TYPE_FUSION)
end
function c43990991.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9510) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetReasonEffect()~=re
end
function c43990991.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990991.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990991.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--闪耀的回声
function c28325122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28325122+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28325122.cost)
	--e1:SetTarget(c28325122.target)
	e1:SetOperation(c28325122.activate)
	c:RegisterEffect(e1)
	--copy(spsummon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,28325122)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28325122.cptg)
	e2:SetOperation(c28325122.cpop)
	c:RegisterEffect(e2)
end
function c28325122.ofilter(e)
	local ct=#c28325122.effect_list
	if (e:IsHasRange(LOCATION_ONFIELD) or (e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SPSUMMON_SUCCESS or e:GetCode()==EVENT_FLIP) and (e:GetType()&EFFECT_TYPE_SINGLE)~=0) and e:IsActivated() then c28325122.effect_list[ct+1]=e end
	return false--e:IsHasRange(LOCATION_ONFIELD) and e:IsActivated()
end
function c28325122.costfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()) then return false end
	c28325122.effect_list={}
	c:IsOriginalEffectProperty(c28325122.ofilter)
	for _,te in ipairs(c28325122.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return true end
	end
	return false
end
function c28325122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28325122.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28325122.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(g)
end
function c28325122.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	c28325122.effect_list={}
	tc:IsOriginalEffectProperty(c28325122.ofilter)
	local e_list={}
	for _,te in ipairs(c28325122.effect_list) do
		local tg=te:GetTarget()
		local check=true
		for _,ce in ipairs(e_list) do--compare
			if ce:GetDescription()==te:GetDescription() then check=false break end
		end
		if check and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28325122.effect_list,i) end
	end
	if #e_list==0 then return end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c28325122.effect_list={}
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(0)--Original Property
end
function c28325122.efilter(e)
	local ct=#c28325122.effect_list
	if (e:IsHasRange(LOCATION_HAND) or e:GetCode()==EVENT_TO_HAND and (e:GetType()&EFFECT_TYPE_SINGLE)~=0) and e:IsActivated() then c28325122.effect_list[ct+1]=e end
	return false--e:IsHasRange(LOCATION_HAND) and e:IsActivated()
end
function c28325122.cpfilter(c,e,tp,eg,ep,ev,re,r,rp,chk)
	if not (c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER)) then return false end
	local exc=chk==0 and e:GetHandler() or nil
	c28325122.effect_list={}
	c:IsOriginalEffectProperty(c28325122.efilter)
	for _,te in ipairs(c28325122.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(te,tp,eg,ep,ev,re,r,rp,0,nil,exc) then return true end
	end
	return false
end
function c28325122.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28325122.cpfilter,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp,0) end
end
function c28325122.cpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28325122.cpfilter,tp,LOCATION_HAND,0,nil,e,tp,eg,ep,ev,re,r,rp,1)
	if #g==0 then return end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	c28325122.effect_list={}
	tc:IsOriginalEffectProperty(c28325122.efilter)
	local e_list={}
	for _,te in ipairs(c28325122.effect_list) do
		local tg=te:GetTarget()
		local check=true
		for _,ce in ipairs(e_list) do--compare
			if ce:GetDescription()==te:GetDescription() then check=false break end
		end
		if check and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28325122.effect_list,i) end
	end
	if #e_list==0 then return end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c28325122.effect_list={}
	--copy
	local tg,op=te:GetTarget(),te:GetOperation()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+28325122)
	e1:SetProperty(te:GetProperty())
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(tg)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) or Group.CreateGroup()
		for tc in aux.Next(g) do tc:CreateEffectRelation(e) tc:CreateEffectRelation(e1) end
		op(e,tp,eg,ep,ev,re,r,rp)
		for tc in aux.Next(g) do tc:ReleaseEffectRelation(e) tc:ReleaseEffectRelation(e1) end
		end)
	--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc:CreateEffectRelation(e)--Card.IsRelateToChain
	tc:CreateEffectRelation(e1)--Card.IsRelateToEffect
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28325122,e,REASON_EFFECT,tp,tp,0)
	tc:ReleaseEffectRelation(e)
	tc:ReleaseEffectRelation(e1)
	if e1 then e1:Reset() end
	--[[tc:CreateEffectRelation(e)--Card.IsRelateToChain
	tc:CreateEffectRelation(te)--Card.IsRelateToEffect
	local tg=te:GetTarget()
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end]]
end

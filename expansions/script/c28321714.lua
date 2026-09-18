--放课后时间胶囊！
function c28321714.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28321714.target)
	e1:SetOperation(c28321714.activate)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28321714,1))
	--e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28321714.cpcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28321714.cptg)
	e2:SetOperation(c28321714.cpop)
	c:RegisterEffect(e2)
	if not c28321714.global_check then
		c28321714.global_check=true
		for i=0,6 do
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_IMMUNE_EFFECT)
			ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			ge1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,1<<i))
			ge1:SetLabel(1<<i)
			ge1:SetValue(c28321714.immval)
			Duel.RegisterEffect(ge1,0)
		end
		c28321714.effect_list={}
	end
end
function c28321714.immval(e,te,c)
	if not (c:IsLevel(4) and te:GetOwnerPlayer()~=c:GetControler() and te:IsActivated() and Duel.IsChainSolving()) then return false end
	--
	local res=true--ctns;contains?
	for _,se in pairs({c:IsHasEffect(EFFECT_FLAG_EFFECT+28321714)}) do
		if se:GetLabelObject()==te and se:GetLabel()==Duel.GetCurrentChain() then res=false end
	end
	--
	local t={Duel.GetFlagEffectLabel(c:GetControler(),28321714)}--IsPlayerAffectedByEffect
	local attr_check=false
	for _,v in pairs(t) do
		if v==e:GetLabel() then attr_check=true end
	end
	if not (res and attr_check) then return false end
	if res then
		--Duel.HintSelection(Group.FromCards(te:GetHandler()))--debug
		Duel.Hint(HINT_CARD,0,28321714)
		local ge1=c:RegisterFlagEffect(28321714,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
		ge1:SetLabelObject(te)
		ge1:SetLabel(Duel.GetCurrentChain())
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_BREAK_EFFECT)
		e0:SetOperation(function(fe) ge1:SetLabelObject(nil) fe:Reset() end)
		Duel.RegisterEffect(e0,0)
		local e1=e0:Clone()
		e1:SetCode(EVENT_ADJUST)
		Duel.RegisterEffect(e1,0)
		--
		Duel.ResetFlagEffect(c:GetControler(),28321714)
		for _,v in pairs(t) do
			if c:IsNonAttribute(v) then
				Duel.RegisterFlagEffect(c:GetControler(),28321714,RESET_PHASE+PHASE_END,0,1,v)
			end
		end
	end
	return true
end
function c28321714.chkfilter(c)
	return (c:IsOnField() or c:IsLevel(4)) and c:IsFaceupEx()
end
function c28321714.tgfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToGrave()
end
function c28321714.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28321714.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.GetMatchingGroupCount(c28321714.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>0 and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28321714.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28321714.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.GetMatchingGroupCount(c28321714.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 and ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	Duel.ConfirmCards(1-tp,cg)
	for i=0,6 do
		if cg:IsExists(Card.IsAttribute,1,nil,1<<i) then
			Duel.RegisterFlagEffect(tp,28321714,RESET_PHASE+PHASE_END,0,1,1<<i)
		end
	end
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c28321714.tgfilter,tp,LOCATION_DECK,0,#cg,#cg,nil)
	Duel.SendtoGrave(tg,REASON_EFFECT)
	--[[--immune
	local fid=e:GetHandler():GetFieldID()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	--e1:SetTarget(c28321714.immtg)--aux.TargetBoolFunction(Card.IsLevel,4)
	e1:SetValue(c28321714.immval)
	e1:SetLabel(attr,fid)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)]]
end
--[[function c28321714.immfilter(c,attr,fid)
	if not (c:IsLevel(4) and c:IsAttribute(attr)) then return false end
	local res=true
	for _,v in pairs({c:GetFlagEffectLabel(28321714)})
		if v==fid then res=false end
	end
	return res
end
function c28321714.immval(e,te,c)
	local attr,fid=e:GetLabel()
	local cont=false--ctns;contains?
	if te:GetOwner()~=e:GetOwnerPlayer() and te:IsActivated() and Duel.IsChainSolving() then
		for _,se in pairs({c:IsHasEffect(EFFECT_FLAG_EFFECT+28321714+1)}) do
			if se:GetLabelObject()==te and se:GetLabel()==Duel.GetCurrentChain() then cont=true end
		end
	end
	local res=cont or (te:GetOwner()~=e:GetOwnerPlayer() and te:IsActivated() and Duel.IsChainSolving() and c28321714.immfilter(c,attr,fid))
	if res and not cont then
		Duel.Hint(HINT_CARD,0,28321714)
		c:RegisterFlagEffect(28321714,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		e:SetLabel(attr&~c:GetAttribute(),fid)
		local ge1=c:RegisterFlagEffect(28321714+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
		ge1:SetLabelObject(te)
		ge1:SetLabel(Duel.GetCurrentChain())
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_BREAK_EFFECT)
		e0:SetOperation(function(fe) ge1:SetLabelObject(nil) fe:Reset() end)
		Duel.RegisterEffect(e0,0)
		local e1=e0:Clone()
		e1:SetCode(EVENT_ADJUST)
		Duel.RegisterEffect(e1,0)
	end
	return res
end]]
function c28321714.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE) and not eg:IsContains(e:GetHandler())
end
function c28321714.efilter(e)
	local ct=#c28321714.effect_list
	if e:IsHasRange(LOCATION_HAND) and e:IsActivated() then c28321714.effect_list[ct+1]=e end
	return false
end
function c28321714.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER)) then return false end
	c28321714.effect_list={}
	c:IsOriginalEffectProperty(c28321714.efilter)
	for _,te in ipairs(c28321714.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(te,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function c28321714.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28321714.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
end
function c28321714.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28321714.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	c28321714.effect_list={}
	tc:IsOriginalEffectProperty(c28321714.efilter)
	local e_list={}
	for _,te in ipairs(c28321714.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(te,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28321714.effect_list,i) end
	end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c28321714.effect_list={}
	--copy
	e:SetProperty(te:GetProperty())
	tc:CreateEffectRelation(e)--Card.IsRelateToChain
	tc:CreateEffectRelation(te)--Card.IsRelateToEffect
	local tg=te:GetTarget()
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
end
function c28321714.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28321714.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28321714.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28321714.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

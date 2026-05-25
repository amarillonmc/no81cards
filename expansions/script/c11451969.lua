--秘计螺旋 愁云
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m-5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.chcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsCode(m-5) and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=1 end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1972,1) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>ft end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1972,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1972,1)
		tc=g:GetNext()
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,code)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		local tc=sg:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
		te:UseCountLimit(tp,1,true)
		local cost=te:GetCost()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if not tc:IsType(TYPE_EQUIP) then tc:CancelToGrave(false) end
		tc:CreateEffectRelation(te)
		if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			for fc in aux.Next(g) do
				fc:CreateEffectRelation(te)
			end
		end
		if operation then
			operation(te,tp,ceg,cep,cev,cre,cr,crp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			for fc in aux.Next(g) do
				fc:ReleaseEffectRelation(te)
			end
		end
	end   
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x836)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if rp==tp then return Duel.IsExistingMatchingCard(cm.disfilter,tp,0,LOCATION_ONFIELD,1,nil)
		else return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_ONFIELD,0,1,nil) end
		--if rp==tp then return Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		--else return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,2,nil) and Duel.IsPlayerCanDraw(1-tp,2) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>1 end
	end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_ONFIELD,nil)
	for nc in aux.Next(ng) do
		Duel.NegateRelatedChain(nc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		nc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			nc:RegisterEffect(e3)
		end
	end
	--[[local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e2,tp)--]]
end
function cm.disfilter(c)
	return c:GetCounter(0x1972)>0 and aux.NegateAnyFilter(c) --(not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,2,2,nil)
	if Duel.SSet(tp,sg,tp,false)>0 then Duel.Draw(tp,2,REASON_EFFECT) end
end
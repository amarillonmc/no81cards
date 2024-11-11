--抹杀之锁名者
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65681983+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chainchk=e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>0
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
		if not chainchk then return #g>0 end
		for i=1,Duel.GetCurrentChain() do
			local tgp,te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
			local code,code2=te:GetHandler():GetOriginalCodeRule()
			if tgp~=tp and g:IsExists(Card.IsCode,1,nil,code,code2) then return true end
		end
		return false
	end
	local chainchk=e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>1
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local codes0={}
	local ag=Group.CreateGroup()
	local codes={}
	if chainchk then
		for i=1,Duel.GetCurrentChain() do
			local tgp,te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
			local code,code2=te:GetHandler():GetOriginalCodeRule()
			local tg=g:Filter(Card.IsCode,nil,code,code2)
			if tgp~=tp and #tg>0 then
				ag:Merge(tg)
				table.insert(codes,code)
				if code2 then table.insert(codes,code2) end
			end
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
		for c in aux.Next(g) do
			local code=c:GetCode()
			if not ag:IsExists(Card.IsCode,1,nil,code) then
				ag:AddCard(c)
				table.insert(codes,code)
			end
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	if chainchk then
		getmetatable(e:GetHandler()).announce_filter=afilter
	else
		getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	end
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c,code)
	return c:IsAbleToRemove() and c:IsCode(code)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,ac):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(cm.distg1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(cm.distg2)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
	else
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function cm.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
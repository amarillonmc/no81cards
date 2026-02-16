--乐士奏音 《残破之躯》
function c19209713.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(19209713,3))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c19209713.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19209713.target)
	e1:SetOperation(c19209713.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209713,2))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209713.rectg)
	e2:SetOperation(c19209713.recop)
	c:RegisterEffect(e2)
end
function c19209713.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)~=0
end
function c19209713.tffilter(c,tp)
	return c:IsCode(19209696) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c19209713.gcheck(g)
	return g:IsExists(Card.IsCode,1,nil,19209711)
end
function c19209713.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c19209713.tffilter,tp,LOCATION_DECK,0,1,nil,tp)
	local g=Duel.GetReleaseGroup(tp)
	local b2=g:CheckSubGroup(c19209713.gcheck,2,2)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209713,0)},
		{b2,aux.Stringid(19209713,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	elseif op==2 then
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g:SelectSubGroup(tp,c19209713.gcheck,false,2,2)
		Duel.Release(rg,REASON_COST)
		local pg=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_HAND,nil)
		local ag=Group.CreateGroup()
		local codes={}
		for tc in aux.Next(pg) do
			local code=tc:GetCode()
			if not ag:IsExists(Card.IsCode,1,nil,code) then
				ag:AddCard(tc)
				table.insert(codes,code)
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
		getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	end
end
function c19209713.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c19209713.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	elseif op==2 then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c19209713.distg1)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c19209713.discon)
		e2:SetOperation(c19209713.disop)
		e2:SetLabel(ac)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c19209713.distg2)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
	end
end
function c19209713.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c19209713.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c19209713.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c19209713.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c19209713.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)*300)
end
function c19209713.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Recover(tp,ct*300,REASON_EFFECT)
end

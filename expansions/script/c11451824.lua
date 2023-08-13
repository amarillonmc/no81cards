--回响虚诞之林
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.ngop)
	c:RegisterEffect(e2)
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local attr=0
	for tc in aux.Next(eg) do
		if tc:GetSummonPlayer()==tp then attr=attr|tc:GetAttribute() end
	end
	if attr&0x1d==0 then return end
	local off=1
	local ops={}
	local opval={}
	if attr&ATTRIBUTE_WIND>0 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if attr&ATTRIBUTE_EARTH>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if attr&ATTRIBUTE_FIRE>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if attr&ATTRIBUTE_LIGHT>0 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	ops[off]=aux.Stringid(m,4)
	opval[off-1]=5
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_ONFIELD,nil)
		if g and #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			c:RegisterFlagEffect(m-10,RESET_CHAIN,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e3)
			end
		end
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_ONFIELD,nil)
		if g and #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			c:RegisterFlagEffect(m-10,RESET_CHAIN,0,1)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local tc=g:Select(1-tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	elseif opval[op]==3 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_SOLVING)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetOperation(cm.ceop2)
		Duel.RegisterEffect(e0,tp)
	elseif opval[op]==4 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0x7f,0x7f)
		e1:SetTarget(cm.catg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(cm.caval)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.catg(e,c)
	return c:IsCode(11451461) and c:IsType(TYPE_MONSTER)
end
function cm.caval(e,c)
	if c:IsAttribute(ATTRIBUTE_DEVINE) then return 0x7f end
	return 0x3f
end
function cm.ceop2(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:GetHandler():IsCode(11451461) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_CARD,0,m)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.reop)
		e:Reset()
	end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) end
end
function cm.filter1(c,tp)
	return c:IsCode(11451461) and aux.disfilter1(c)
end
function cm.filter2(c,tp)
	return c:IsCode(11451461) and c:IsFaceup()
end
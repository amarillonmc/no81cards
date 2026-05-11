--空竞名宿 各务葵
function c9910241.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9910241.matfilter,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--remove & to deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910241)
	e3:SetCondition(c9910241.condition)
	e3:SetTarget(c9910241.target)
	e3:SetOperation(c9910241.operation)
	c:RegisterEffect(e3)
end
function c9910241.matfilter(c)
	return c:IsLinkRace(RACE_PSYCHO) and c:IsLinkType(TYPE_LINK)
end
function c9910241.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c9910241.filter(c)
	return c9910241.filter1(c) or c9910241.filter2(c)
end
function c9910241.filter1(c)
	return (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER))) and c:IsAbleToRemove()
end
function c9910241.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c9910241.fselect(g)
	return g:IsExists(c9910241.filter,1,nil)
end
function c9910241.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e)
	if chkc then return false end
	if chk==0 then return dg:IsExists(c9910241.filter,1,nil) end
	local num=math.floor(Duel.GetCurrentChain()/2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=dg:SelectSubGroup(tp,c9910241.fselect,false,1,num)
	Duel.SetTargetCard(g)
	local b1=g:IsExists(c9910241.filter1,1,nil)
	local b2=g:IsExists(c9910241.filter2,1,nil)
	local b3=g:CheckSubGroup(aux.gffcheck,2,2,c9910241.filter1,nil,c9910241.filter2,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910241,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910241,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(9910241,2)
		opval[off-1]=3
	end
	local op=opval[Duel.SelectOption(tp,table.unpack(ops))]
	e:SetLabel(op)
	e:SetCategory(0)
	if op&1>0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
	if op&2>0 then
		e:SetCategory(e:GetCategory()|CATEGORY_TODECK)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION) end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function c9910241.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local res=false
	if op&1>0 then
		local tg1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #tg1>0 and not aux.NecroValleyNegateCheck(tg1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg1=tg1:FilterSelect(tp,c9910241.filter1,1,1,nil)
			if #sg1>0 then
				res=true
				Duel.HintSelection(sg1)
				local tc=sg1:GetFirst()
				local fid=c:GetFieldID()
				if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0
					and not tc:IsReason(REASON_REDIRECT) then
					tc:RegisterFlagEffect(9910241,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_CHAIN_SOLVED)
					e1:SetLabel(fid)
					e1:SetLabelObject(tc)
					e1:SetCondition(c9910241.retcon)
					e1:SetOperation(c9910241.retop)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EVENT_CHAIN_NEGATED)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
	if op&2>0 then
		local tg2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #tg2>0 and not aux.NecroValleyNegateCheck(tg2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg2=tg2:FilterSelect(tp,c9910241.filter2,1,1,nil)
			if #sg2>0 then
				if op==3 and res then Duel.BreakEffect() end
				Duel.HintSelection(sg2)
				Duel.SendtoDeck(sg2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
function c9910241.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9910241)==e:GetLabel() then
		return Duel.GetCurrentChain()==1
	else
		e:Reset()
		return false
	end
end
function c9910241.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local loc=tc:GetPreviousLocation()
	if loc==LOCATION_MZONE then
		Duel.ReturnToField(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(c9910241.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if loc==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
	e:Reset()
end
function c9910241.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and re:IsHasType(EFFECT_TYPE_SINGLE) and re:GetCode() and re:GetCode()==EVENT_REMOVE
end

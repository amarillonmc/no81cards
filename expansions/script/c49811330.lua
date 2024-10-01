--珍遺の魔導士
function c49811330.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811330,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,49811330)
	e1:SetCost(c49811330.cost)
	e1:SetTarget(c49811330.tg)
	e1:SetOperation(c49811330.op)
	c:RegisterEffect(e1)
	if not c49811330.global_check then
		c49811330.global_check=true
		c49811330.tab = {}
		c49811330.stab = {}
	end
end
function c49811330.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()
end
function c49811330.ffilter(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c49811330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c49811330.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c49811330.ffilter,3,#g) and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local gs=g:SelectSubGroup(tp,c49811330.ffilter,false,3,3)
	Duel.ConfirmCards(1-tp,gs)
	local dc=gs:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local hc=gs:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local tc=gs:GetFirst()
	local code1=tc:GetCode()
	Duel.Hint(HINT_CARD,1,code1)
	Duel.Hint(HINT_CODE,1,code1)
	tc=gs:GetNext()
	local code2=tc:GetCode()
	Duel.Hint(HINT_CARD,1,code2)
	Duel.Hint(HINT_CODE,1,code2)
	tc=gs:GetNext()
	local code3=tc:GetCode()
	Duel.Hint(HINT_CARD,1,code3)
	Duel.Hint(HINT_CODE,1,code3)
	tc=gs:GetNext()
	if #dc>0 then 
		Duel.ShuffleDeck(tp)
	end
	if #hc>0 then 
		Duel.ShuffleHand(tp)
		e:SetLabel(1,code1,code2,code3)
	else
		e:SetLabel(0,code1,code2,code3)
	end
	--for ci in aux.Next(gs) do
	--	table.insert(c49811330.tab,Card.GetCode(ci))
	--	Duel.Hint(HINT_CARD,1,Card.GetCode(ci))
	--	Duel.Hint(HINT_CODE,1,Card.GetCode(ci))
	--end	
end
function c49811330.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811330.sfilter(c,code1,code2,code3)
	return c:IsCode(code1,code2,code3) and c:IsAbleToGraveAsCost()
	--return c:IsCode(table.unpack(c49811330.tab))
end
function c49811330.op(e,tp,eg,ep,ev,re,r,rp)
	local dlabel,code1,code2,code3=e:GetLabel()
	local c=e:GetHandler()
	if Duel.IsChainDisablable(0) then
		local og=Duel.GetMatchingGroup(c49811330.sfilter,tp,0,LOCATION_DECK+LOCATION_HAND,nil,code1,code2,code3)
		local sel=1
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(49811330,1))
		if og:GetCount()>0 then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=og:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)	
	if Duel.Draw(p,d,REASON_EFFECT) and dlabel==1 and Duel.SelectYesNo(tp,aux.Stringid(49811330,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(1,0)
	e1:SetLabel(code1,code2,code3)
	e1:SetTarget(c49811330.adlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(code1,code2,code3)
	e2:SetTarget(c49811330.sslimit)
	Duel.RegisterEffect(e2,tp)
	--local e21=Effect.CreateEffect(c)
	--e21:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e21:SetCode(EVENT_CHAINING)
	--e21:SetOperation(c49811330.sregop)
	--Duel.RegisterEffect(e21,tp)
	--local e22=Effect.CreateEffect(c)
	--e22:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e22:SetCode(EVENT_CHAIN_SOLVING)
	--e22:SetOperation(c49811330.sregop2)
	--Duel.RegisterEffect(e22,tp)
	--local e23=Effect.CreateEffect(c)
	--e23:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e23:SetCode(EVENT_CHAIN_SOLVED)
	--e23:SetOperation(c49811330.sregop3)
	--e23:SetLabelObject(e)
	--Duel.RegisterEffect(e23,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetLabel(code1,code2,code3)
	e3:SetCondition(c49811330.regcon)
	e3:SetOperation(c49811330.regop)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCondition(c49811330.drcon)
	e4:SetOperation(c49811330.drop)
	Duel.RegisterEffect(e4,tp)
end
--function c49811330.sregop(e,tp,eg,ep,ev,re,r,rp)
--	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
--		table.insert(c49811330.stab,re)
--	end
--end
--function c49811330.sregop2(e,tp,eg,ep,ev,re,r,rp)
--	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then
--		table.insert(c49811330.stab,re)
--	end
--end
--function c49811330.sregop3(e,tp,eg,ep,ev,re,r,rp)
--	if re==e:GetLabelObject() then return end
--	table.remove(c49811330.stab)
--end
function c49811330.adlimit(e,c)
	local code1,code2,code3=e:GetLabel()
	return c:IsCode(code1,code2,code3)
end
function c49811330.sslimit(e,c)
	local code1,code2,code3=e:GetLabel()
	return c:IsCode(code1,code2,code3) and Duel.GetCurrentChain() > 0
	--if #c49811330.stab > 0 then
		--return aux.TargetBoolFunction(Card.IsCode,code1,code2,code3) and c49811330.stab[#c49811330.stab]:GetOwnerPlayer()==tp
	--end
end
function c49811330.regcon(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2,code3=e:GetLabel()
	local c=re:GetHandler()
	--return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsCode(table.unpack(c49811330.tab))
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsCode(code1,code2,code3)
end
function c49811330.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(49811330,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c49811330.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:GetFlagEffect(49811330)~=0
end
function c49811330.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811330)
	if Duel.Draw(tp,1,REASON_EFFECT) then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end
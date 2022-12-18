--人理之基 勇者伊丽莎白
function c22022400.initial_effect(c)
	aux.AddCodeList(c,22020850)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020850,c22022400.mfilter,1,true,true)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022400,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22022400)
	e1:SetOperation(c22022400.operation)
	c:RegisterEffect(e1)
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022400,9))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,22022401)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22022400.atkcost)
	e3:SetOperation(c22022400.datop)
	c:RegisterEffect(e3)
end
function c22022400.mfilter(c)
	return c:IsFusionType(TYPE_MONSTER) and aux.IsCodeListed(c,22020850)
end
c22022400.toss_dice=true
function c22022400.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22022400,2))
	local d=Duel.TossDice(tp,1)
	if d==1 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
		Duel.SelectOption(tp,aux.Stringid(22022400,3))
		Duel.Destroy(c,REASON_EFFECT)
		Duel.SelectOption(tp,aux.Stringid(22022400,4))
		end
	elseif d>=2 and d<=4 then
		local c=e:GetHandler()
		Duel.SelectOption(tp,aux.Stringid(22022400,5))
		Duel.SelectOption(tp,aux.Stringid(22022400,6))
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(c:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(c:GetDefense()*2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2)
		end
	elseif d>=5 and d<=6 then
		local g=Duel.GetMatchingGroup(c22022400.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22022400,1)) then
			Duel.SelectOption(tp,aux.Stringid(22022400,7))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.SelectOption(tp,aux.Stringid(22022400,8))
		end
	end
end
function c22022400.filter(c,e,tp)
	return (c:IsCode(22020850) or aux.IsCodeListed(c,22020850)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022400.datop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22022400,12))
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22022400,13))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TOSS_DICE_NEGATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c22022400.dicecon)
		e1:SetOperation(c22022400.diceop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
	end
end
function c22022400.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(22022400)==0
end
function c22022400.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if Duel.SelectYesNo(tp,aux.Stringid(22022400,10)) then
		Duel.Hint(HINT_CARD,0,22022400)
		e:GetHandler():RegisterFlagEffect(22022400,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=(ev&0xff)+(ev>>16&0xff)
		if ct>1 then
			--choose the index of results
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22022400,11))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
			ac=idx+1
		end
		dc[ac]=6
		Duel.SetDiceResult(table.unpack(dc))
	end
end
function c22022400.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-2400,true) end
	e:SetLabel(lp-2400)
	Duel.PayLPCost(tp,lp-2400,true)
end
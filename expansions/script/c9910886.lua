--迷层的少女 艾莉尔
function c9910886.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c9910886.condition)
	e3:SetTarget(c9910886.target)
	e3:SetOperation(c9910886.operation)
	c:RegisterEffect(e3)
end
function c9910886.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c9910886.thfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and aux.IsCodeListed(c,9910871) and not c:IsCode(9910886)
		and c:IsAbleToHand()
end
function c9910886.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsPlayerCanDraw(tp,1) then
		--draw
		ops[off]=aux.Stringid(9910886,0)
		opval[off]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c9910886.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		--recycle
		ops[off]=aux.Stringid(9910886,1)
		opval[off]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) then
		--return to hand
		ops[off]=aux.Stringid(9910886,2)
		opval[off]=4
		off=off+1
	end
	if chk==0 then return off>1 and Duel.CheckLPCost(tp,1000,true) end
	local op=0
	local pay=0
	while pay<3000 and Duel.CheckLPCost(tp,pay+1000,true) do
		local sel
		local selval
		sel=Duel.SelectOption(tp,table.unpack(ops))+1
		selval=opval[sel]
		if pay==0 then
			--stop
			ops[off]=aux.Stringid(9910886,3)
			opval[off]=0
		end
		if selval==0 then break end
		table.remove(ops,sel)
		table.remove(opval,sel)
		op=op|selval
		pay=pay+1000
	end
	Duel.PayLPCost(tp,pay,true)
	e:SetLabel(op)
	local cat=0
	local prop=EFFECT_FLAG_DELAY
	if bit.band(op,1)~=0 then
		cat=cat|CATEGORY_DRAW
		prop=prop|EFFECT_FLAG_PLAYER_TARGET
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if bit.band(op,2)~=0 then
		cat=cat|CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
	if bit.band(op,3)~=0 then
		cat=cat|CATEGORY_TOHAND
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
	end
	e:SetCategory(cat)
	e:SetProperty(prop)
end
function c9910886.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op&1~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
	if op&2~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910886.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op&4~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

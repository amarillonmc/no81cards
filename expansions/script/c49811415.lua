--传说的伪神 蛟
function c49811415.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c49811415.thcost)
	e1:SetTarget(c49811415.thtg)
	e1:SetOperation(c49811415.thop)
	c:RegisterEffect(e1)
	--name change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c49811415.nametg)
	e2:SetOperation(c49811415.nameop)
	c:RegisterEffect(e2)
end
function c49811415.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811415.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c49811415.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c49811415.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	local cg=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	if #cg>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=cg:FilterSelect(p,Card.IsAbleToHand,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)==0 then return end
		Duel.ConfirmCards(1-p,sg)
		Duel.ShuffleHand(p)
		Duel.DiscardHand(tp,c49811415.cfilter,1,1,REASON_EFFECT+REASON_DISCARD)
		g:Sub(sg)
		if #g>0 then
			Duel.SortDecktop(tp,tp,#g)
			for i=1,#g do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
	end
end
function c49811415.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--c:IsRace(RACE_DRAGON) and not c:IsCode(code)
	getmetatable(e:GetHandler()).announce_filter={RACE_DRAGON,OPCODE_ISRACE,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c49811415.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceupEx() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

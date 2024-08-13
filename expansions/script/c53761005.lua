local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(s.acop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(73734821)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),73734821,e,0,tp,tp,Duel.GetCurrentChain())
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler()==e:GetHandler()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.ConfirmCards(1-tp,c) Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function s.hgfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,id) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	local b2=Duel.GetOverlayGroup(tp,1,0):IsExists(Card.IsSSetable,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.hgfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return true end
	local sel=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)},{b3,aux.Stringid(id,3)},{true,aux.Stringid(id,4)})
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
	elseif sel==3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	elseif sel==4 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		getmetatable(e:GetHandler()).announce_filter={53761001,OPCODE_ISCODE,53761002,OPCODE_ISCODE,OPCODE_OR,53761003,OPCODE_ISCODE,OPCODE_OR,53761004,OPCODE_ISCODE,OPCODE_OR}
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if #rg>0 then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
	elseif op==2 then
		local og=Duel.GetOverlayGroup(tp,1,0):Filter(Card.IsSSetable,nil)
		if og:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=og:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
		end
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.hgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()<=0 then return end
		local tc=g:GetFirst()
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	elseif op==4 then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,ac))
		e1:SetValue(400)
		Duel.RegisterEffect(e1,tp)
		local e1_1=e1:Clone()
		e1_1:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e1_1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(ac)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end
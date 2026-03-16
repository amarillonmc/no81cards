local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
end
function s.mtfilter(c,rc,e)
	return c:IsRace(rc) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.thfilter(c,rc)
	return c:IsRace(rc) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(rc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
	
	local b1=c:IsRelateToEffect(e) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.mtfilter,1-tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,rc,e)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToHand,1-tp,LOCATION_DECK,0,1,nil)
	
	if b1 or b2 then
		Duel.BreakEffect()
		local ops={}
		local opval={}
		local off=1
		if b1 then
			ops[off]=aux.Stringid(id,1)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(id,2)
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(1-tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
			local mg=Duel.SelectMatchingCard(1-tp,s.mtfilter,1-tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,rc,e)
			if #mg>0 then
				Duel.Overlay(c,mg)
			end
		elseif sel==1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,rc)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,tg)
			end
		end
	end
	
	-- 发动后限制
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.aclimit)
	e2:SetLabel(rc)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	
	-- 记录发动次数
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetLabel(rc)
	e3:SetOperation(s.regop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.aclimit(e,re,tp)
	local rc=e:GetLabel()
	local loc=re:GetActivateLocation()
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and re:GetHandler():IsRace(rc) and Duel.GetFlagEffect(tp,id)>0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabel()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and re:GetHandler():IsRace(rc) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
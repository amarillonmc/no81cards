--风驰电掣
function c7409797.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7409797.target)
	e1:SetOperation(c7409797.activate)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c7409797.actarget)
	e2:SetOperation(c7409797.acop)
	c:RegisterEffect(e2)
end
c7409797.Grimy_Goons=true
function c7409797.Grimy_Goons_filter(c)
	return c.Grimy_Goons
end
function c7409797.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c7409797.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsPublic() then
		e:GetHandler():RegisterFlagEffect(7409797,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c7409797.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,nil)
end
function c7409797.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:GetFlagEffect(7409797)~=0 then
		local hg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
		local tc=hg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=hg:GetNext()
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c7409797.hatop)
		Duel.RegisterEffect(e2,tp)
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		local tg=Duel.GetOperatedGroup()
		if tg:GetCount()>0 then
			local tc=tg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(7409797,3))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				tc=tg:GetNext()
			end
			local num=tg:Filter(c7409797.Grimy_Goons_filter,nil):GetCount()
			if num==2 then return end
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
			if g:GetCount()==0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:Select(p,2-num,2-num,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
function c7409797.hatop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(c7409797.hatfilter,nil,tp)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=hg:GetNext()
	end
end
function c7409797.hatfilter(c,tp)
	return c:GetControler()==tp and c:IsType(TYPE_MONSTER)
end

--污手党执行者
function c7409793.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7409793.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c7409793.sumcon)
	e2:SetOperation(c7409793.sumsuc)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7409793,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,7409793)
	e3:SetCondition(c7409793.drcon)
	e3:SetTarget(c7409793.drtg)
	e3:SetOperation(c7409793.drop)
	c:RegisterEffect(e3)
end
c7409793.Grimy_Goons=true
function c7409793.Grimy_Goons_filter(c)
	return c.Grimy_Goons
end
function c7409793.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsPublic()
end
function c7409793.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c7409793.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
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
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c7409793.hatop)
	Duel.RegisterEffect(e2,tp)
end
function c7409793.hatop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(c7409793.hatfilter,nil,tp)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
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
end
function c7409793.hatfilter(c,tp)
	return c:GetControler()==tp and c:IsType(TYPE_MONSTER)
end
function c7409793.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND)
end
function c7409793.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,nil)
end
function c7409793.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		local tg=Duel.GetOperatedGroup()
		if tg:GetCount()>0 then
			local tc=tg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(7409793,3))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				tc=tg:GetNext()
			end
			local num=tg:Filter(c7409793.Grimy_Goons_filter,nil):GetCount()
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

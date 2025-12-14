--·Re：从零开始的异世界生活·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337440)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.condition2)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetCountLimit(1,id+1)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	c:RegisterEffect(e3)
end

function s.filter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_MONSTER)
end

function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>=10
end

function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>=10 and Duel.GetAttacker():GetControler()~=tp
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_EXTRA, LOCATION_EXTRA, nil)
	g2=g2:Filter(Card.IsType, nil, TYPE_PENDULUM)
	if #g2>0 then
		g1:Merge(g2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,PLAYER_ALL,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end

function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local dg=Group.CreateGroup()
	local ch=Duel.GetCurrentChain()

	for i=1,ch do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			Duel.NegateActivation(i)
			local tc=te:GetHandler()
			if tc:IsOnField() and tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end

	if dg:GetCount()>0 then
		Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tg=Duel.GetOperatedGroup()
		if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	end

	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD,0)

	if #g1>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end

	if #g2>0 then
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end

	local g3=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local g4=Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_EXTRA, LOCATION_EXTRA, nil)
	g4=g4:Filter(Card.IsType, nil, TYPE_PENDULUM)
	if #g4>0 then
		g3:Merge(g4)
	end
	
	if #g3>0 then
		Duel.SendtoDeck(g3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tg=Duel.GetOperatedGroup()
		if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	end

	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct1<5 then
		Duel.Draw(tp,5-ct1,REASON_EFFECT)
	end
	
	local ct2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ct2<5 then
		Duel.Draw(1-tp,5-ct2,REASON_EFFECT)
	end

	Duel.SetLP(tp,8000)
	Duel.SetLP(1-tp,8000)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(1)
	e5:SetTargetRange(1,1)
	e5:SetValue(1)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)

	local pp=Duel.GetTurnPlayer()
	Duel.SkipPhase(pp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(pp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(pp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(pp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(pp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e2:SetValue(0)
	Duel.RegisterEffect(e2,1-pp)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=pp and Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,pp)

	local sc=Duel.CreateToken(tp,17337440) 
	if sc and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0 
		and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function s.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end

function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x5f50) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() 
		and (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_REMOVED)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re:GetHandlerPlayer()~=tp 
		and eg:IsExists(s.repfilter,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
		return true
	end
	return false
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
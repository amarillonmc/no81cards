--真挚的谎言 美树沙耶香
function c60152904.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c60152904.e1filter,nil,nil,c60152904.e1matfilter,true)
	e1:SetDescription(aux.Stringid(60152904,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,60152904)
	e1:SetCondition(c60152904.e1con)
	c:RegisterEffect(e1)
	if not c60152904.global_check then
		c60152904.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c60152904.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152904,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6012904)
	e2:SetCondition(c60152904.con)
	e2:SetTarget(c60152904.e2tg)
	e2:SetOperation(c60152904.e2op)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60152904,2))
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,602904)
	e3:SetCondition(c60152904.con)
	e3:SetTarget(c60152904.e3tg)
	e3:SetOperation(c60152904.e3op)
	c:RegisterEffect(e3)
end
function c60152904.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c60152904.e1filter(c,e,tp,chk)
	return c:IsSetCard(0x3b29) and (not chk or c~=e:GetHandler())
end
function c60152904.e1matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c60152904.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c60152904.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetControler(),60152904)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),60152904,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,60152904)>0 and Duel.GetFlagEffect(1,60152904)>0 then
			break
		end
		tc=g:GetNext()
	end
end
function c60152904.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return not Duel.GetFlagEffect(1-tp,60152904)==0 end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
end
function c60152904.e2opfilter(c)
	return c:IsAbleToDeck()
end
function c60152904.e2op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local c=e:GetHandler()
		local p1=Duel.GetLP(tp)
		local p2=Duel.GetLP(1-tp)
		local s=p2-p1
		if s<0 then s=p1-p2 end
		local d2=math.floor(s/1000)
		if d2>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c60152904.e2opfilter,tp,0,LOCATION_GRAVE,1,d2,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
function c60152904.e3tgfilter(c)
	return c:IsReleasableByEffect() and c:IsType(TYPE_MONSTER)
end
function c60152904.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/2000)
	if chk==0 then return d>=1 and Duel.IsExistingMatchingCard(c60152904.e3tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end
function c60152904.e3op(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/2000)
	if d>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c60152904.e3tgfilter,tp,LOCATION_DECK,0,1,d,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
		end
	end
end
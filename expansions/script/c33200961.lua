--星辉末裔 丹特
function c33200961.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,c33200961.lcheck)  
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200961,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c33200961.sptg)
	e3:SetOperation(c33200961.spop)
	c:RegisterEffect(e3)
	--gogogo!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200961,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33200961)
	e1:SetCondition(c33200961.phcon)
	e1:SetTarget(c33200961.phtg)
	e1:SetOperation(c33200961.phop)
	c:RegisterEffect(e1)
	if not c33200961.global_check then
		c33200961.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c33200961.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end

function c33200961.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x632a)
end

--e1
function c33200961.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33200961,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c33200961.phcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,33200961)>=5 and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsAbleToEnterBP()
end
function c33200961.phtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c33200961.phop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,0,POS_FACEUP_ATTACK,0)
		local kp=Duel.GetTurnPlayer() 
		if Duel.GetCurrentPhase()<PHASE_BATTLE_START then
			Duel.SkipPhase(kp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(kp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		end 
	end
end

--e3
function c33200961.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c33200961.dspfilter(c)
	return c:IsSetCard(0x632a) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c33200961.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c33200961.dspfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(33200961,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:FilterSelect(tp,c33200961.dspfilter,1,1,nil)
		local sc=sg:GetFirst()
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local satk=math.floor(sc:GetBaseAttack()/2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(satk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.ShuffleDeck(tp)
end

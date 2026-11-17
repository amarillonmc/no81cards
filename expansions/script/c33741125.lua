--Fearmongering \"Z\"
function c33741125.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetDescription(aux.Stringid(33741125,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33741125)
	e1:SetCondition(c33741125.drcon)
	e1:SetTarget(c33741125.drtg)
	e1:SetOperation(c33741125.drop)
	c:RegisterEffect(e1)
	if not c33741125.global_check then
		c33741125.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c33741125.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c33741125.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33741125,RESET_PHASE+PHASE_END,0,1)
	end
end
function c33741125.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,33741125)>=5 and Duel.IsMainPhase()
end
function c33741125.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetMZoneCount(1-tp,nil,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33741125.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)==0 then return end
	local b1=Duel.IsPlayerCanDraw(tp,6)
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(1-tp,
		{b1,aux.Stringid(33741125,0)},
		{b2,aux.Stringid(33741125,1)})
	if op==1 then
		Duel.Draw(tp,6,REASON_EFFECT)
	elseif op==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local p=Duel.GetTurnPlayer()
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_END,RESET_PHASE+PHASE_END,1)
		if p==tp then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SKIP_TURN)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.SkipPhase(1-p,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(1-p,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	end
end

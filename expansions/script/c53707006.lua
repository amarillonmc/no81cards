local m=53707006
local cm=_G["c"..m]
cm.name="缘清响 继辰翼"
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.damcon)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsLinkRace(RACE_PLANT) and c:IsLevelAbove(1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.plfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsFacedown()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.plfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,cm.plfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveSequence(tc,0)
		tc:ReverseInDeck()
		Duel.BreakEffect()
		local turnp=Duel.GetTurnPlayer()
		local ph=Duel.GetCurrentPhase()
		if ph==PHASE_DRAW then
			Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,turnp)
		end
		if ph==PHASE_STANDBY then
			Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,turnp)
		end
		if ph==PHASE_MAIN1 then
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,turnp)
		end
		if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
			Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
		if ph==PHASE_MAIN2 then
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and rp==1-tp and c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

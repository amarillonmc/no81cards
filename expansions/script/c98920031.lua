--巨石遗物·阿巴太尔
function c98920031.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920031.splimit)
	c:RegisterEffect(e1)
--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SPSUMMON_COST)  
	e1:SetCost(c98920031.spcost)  
	c:RegisterEffect(e1)
--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c98920031.filter,nil,nil,c98920031.matfilter,true)
	e1:SetDescription(aux.Stringid(98920031,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,98920031)
	e1:SetCondition(c98920031.rscon)
	e1:SetCost(c98920031.rscost)
	c:RegisterEffect(e1)
--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920031,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c98920031.destg)
	e4:SetOperation(c98920031.desop)
	c:RegisterEffect(e4)
end
function c98920031.splimit(e,se,sp,st)
	return e:GetHandler():IsLocation(LOCATION_HAND) and bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c98920031.mat_filter(c,tp)
	return c:IsSetCard(0x138) and c:IsControler(tp)
end
function c98920031.mat_group_check(g)
	return #g>=3
end
function c98920031.spcost(e,c,tp,st)  
	if bit.band(st,SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL then return true end  
	return Duel.GetTurnPlayer()==tp
end  
function c98920031.filter(c,e,tp,chk)
	return c:IsSetCard(0x138) and (not chk or c~=e:GetHandler())
end
function c98920031.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c98920031.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98920031.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c98920031.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920031.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
		Duel.BreakEffect()
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1) 
		local turnp=Duel.GetTurnPlayer()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)			 
	end	
end
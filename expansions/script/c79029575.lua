--急星壳·熄炎
function c79029575.initial_effect(c)
	--pendulum summon
	aux.AddFusionProcFunRep2(c,c79029575.ffilter,3,3,true)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()  
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029575.efilter)
	e2:SetCondition(c79029575.imcon)
	c:RegisterEffect(e2)   
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97007933,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c79029575.spcon)
	e3:SetCost(c79029575.spcost)
	e3:SetTarget(c79029575.sptg)
	e3:SetOperation(c79029575.spop)
	c:RegisterEffect(e3) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(c79029575.thtg)
	e1:SetOperation(c79029575.thop)
	c:RegisterEffect(e1)
end
function c79029575.ffilter(c)
	return c:IsRace(RACE_MACHINE)
end
function c79029575.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029575.fil1(c)
	return c:IsType(TYPE_FUSION)
end
function c79029575.fil2(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c79029575.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  (c:GetMaterial():IsExists(c79029575.fil1,1,nil) and c:IsSummonType(SUMMON_TYPE_SYNCHRO))
	or (c:GetMaterial():IsExists(c79029575.fil2,1,nil) and c:IsSummonType(SUMMON_TYPE_FUSION))
end
function c79029575.seqfil(c)
	return c:GetSequence()<5
end
function c79029575.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c79029575.seqfil,tp,LOCATION_MZONE,0,1,nil)
end
function c79029575.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c79029575.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029575.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029575.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil) 
	g:Merge(g1) 
	Duel.SetTargetCard(g)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,tp,0)
	Duel.SetChainLimit(c79029575.limit(g:GetFirst()))
	Duel.SetChainLimit(c79029575.limit(g:GetNext()))
end
function c79029575.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c79029575.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end






--『二重之虹』市谷有咲
function c65010028.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65010028.ffilter,2,true)
	aux.EnablePendulumAttribute(c,false)
	--destroy
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e0:SetCountLimit(1,65010028)
	e0:SetCondition(c65010028.condition)
	e0:SetCost(c65010028.cost)
	e0:SetTarget(c65010028.target)
	e0:SetOperation(c65010028.operation)
	c:RegisterEffect(e0)
	 --negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65010027)
	e1:SetCondition(c65010028.discon)
	e1:SetTarget(c65010028.distg)
	e1:SetOperation(c65010028.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(c65010028.pencon)
	e8:SetTarget(c65010028.pentg)
	e8:SetOperation(c65010028.penop)
	c:RegisterEffect(e8)
end
function c65010028.atkcon(e,c)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65010028.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end
function c65010028.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c65010028.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c65010028.ffilterfil(c,att,rac)
	return c:IsAttribute(att) and c:IsRace(rac)
end
function c65010028.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or sg:IsExists(c65010028.ffilterfil,1,c,c:GetFusionAttribute(),c:GetRace())
			 or c:IsType(TYPE_TOKEN)
end
function c65010028.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c65010028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST+REASON_DISCARD)
end
function c65010028.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010028.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

function c65010028.disconfil(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsAbleToDeck() and c:IsAttackAbove(1)
end
function c65010028.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c65010028.disconfil,nil,tp)==1
end
function c65010028.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c65010028.disconfil,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c65010028.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65010028.disconfil,nil,tp)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end

--至星壳·魔王II
function c79029573.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_LINK),1,1)
	c:EnableReviveLimit()	
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c79029573.stgtarget)
	e1:SetOperation(c79029573.stgoperation)
	c:RegisterEffect(e1) 
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c79029573.atkcon)
	e3:SetCost(c79029573.atkcost)
	e3:SetOperation(c79029573.atkop)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,79029573)
	e3:SetCost(c79029573.spcost)
	e3:SetTarget(c79029573.sptg)
	e3:SetOperation(c79029573.spop)
	c:RegisterEffect(e3)
	
end
function c79029573.dfil(c,e)
	return c:IsFaceup() and c:IsAttackBelow(e:GetHandler():GetAttack())
end
function c79029573.stgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetMatchingGroupCount(c79029573.dfil,tp,0,LOCATION_MZONE,nil,e)>=1 end
	local g=Duel.GetMatchingGroup(c79029573.dfil,tp,0,LOCATION_MZONE,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029573.stgoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029573.dfil,tp,0,LOCATION_MZONE,nil,e)
	local x=Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,x*1000,REASON_EFFECT)
end
function c79029573.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0
end
function c79029573.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(79029573)==0 end
	c:RegisterFlagEffect(79029573,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c79029573.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c79029573.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)
end
function c79029573.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,false) and c:IsCode(79029572)
end
function c79029573.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029573.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029573.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c79029573.cpfil(c,e,tp)
	return c:IsAbleToGrave() and c:IsType(TYPE_RITUAL)
end
function c79029573.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c79029573.cpfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029573,0)) then
	local g=Duel.SelectMatchingCard(tp,c79029573.cpfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	tc:CopyEffect(g:GetFirst():GetOriginalCode(),RESET_EVENT+RESETS_STANDARD)
	tc:SetHint(CHINT_CARD,g:GetFirst():GetOriginalCode())  
	end
end






--盛夏回忆·瓢虫
function c65810035.initial_effect(c)
	aux.AddSynchroProcedure(c,c65810035.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--降2星特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65810035)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c65810035.scon)
	e1:SetTarget(c65810035.target)
	e1:SetOperation(c65810035.operation)
	c:RegisterEffect(e1)
	--战破抗性
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--加通召
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c65810035.scon)
	e4:SetOperation(c65810035.sumop)
	c:RegisterEffect(e4)
end



function c65810035.tfilter(c)
	return c:IsRace(RACE_INSECT)
end


function c65810035.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65810035.spfilter(c,e,tp)
	return c:IsSetCard(0xa31) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65810035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65810035.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65810035.spcheck(g)
	return g:GetSum(Card.GetLevel)<=4
end
function c65810035.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local tg=Duel.GetMatchingGroup(c65810035.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=c65810035.spcheck
	local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,ft)
	aux.GCheckAdditional=nil
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end


function c65810035.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,65810035)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(65810035,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa31))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,65810035,RESET_PHASE+PHASE_END,0,1)
end

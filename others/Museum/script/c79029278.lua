--个人行动-深渊回响
function c79029278.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029278)
	e1:SetTarget(c79029278.target)
	e1:SetOperation(c79029278.activate)
	c:RegisterEffect(e1)  
	--ex
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029278)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c79029278.exop)
	c:RegisterEffect(e2) 
end
function c79029278.exop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029278,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c79029278.exstg)
	Duel.RegisterEffect(e2,tp)
	Debug.Message("......听，茫茫的万物之主，在黑暗中，喃喃自语......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029278,2))
end
function c79029278.exstg(e,c)
	return c:IsSetCard(0xa900)
end
function c79029278.tkfil(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:GetMaterialCount()>0
end
function c79029278.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029278.tkfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and Duel.IsPlayerCanSpecialSummonMonster(tp,79029101,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WATER) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Debug.Message("慈悲的使者，请守卫我的睡梦，保护我的心灵......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029278,1))
	local g=Duel.SelectMatchingCard(tp,c79029278.tkfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.SetTargetCard(g)
	local x=g:GetMaterialCount()
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,x,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,x,0,0)
end
function c79029278.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft1=tc:GetMaterialCount()
	for i=1,ft1 do
	local token=Duel.CreateToken(tp,79029101)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end








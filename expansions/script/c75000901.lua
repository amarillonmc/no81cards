--邪龙 鲁弗莱
function c75000901.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75000901,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e0) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75000901.target)
	e1:SetOperation(c75000901.activate)
	c:RegisterEffect(e1)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000901,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,75000901)
	e3:SetCondition(c75000901.spcon)
	e3:SetTarget(c75000901.sptg)
	e3:SetOperation(c75000901.spop)
	c:RegisterEffect(e3)	  
end
function c75000901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75000901,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75000901.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,75000901,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
--
function c75000901.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsSSetable()
end
function c75000901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75000901,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75000901.thfilter(c)
	return c:IsCode(75000903) and c:IsAbleToHand()
end
function c75000901.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,75000901,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,75000908,0,TYPES_TOKEN_MONSTER,1700,0,6,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) 
			and Duel.SelectYesNo(tp,aux.Stringid(75000901,2)) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,75000908)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


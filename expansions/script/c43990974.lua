--除恶险兽
function c43990974.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990974,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c43990974.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990974,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990974.target)
	e1:SetOperation(c43990974.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(43990974,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,43990974)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43990974.settg)
	e2:SetOperation(c43990974.setop)
	c:RegisterEffect(e2)
end
function c43990974.hcfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end
function c43990974.cfilter(c)
	return c:IsCode(43990987) and c:IsFaceup()
end
function c43990974.handcon(e)
	return not Duel.IsExistingMatchingCard(c43990974.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c43990974.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c43990974.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43990974,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990974.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.IsPlayerCanSpecialSummonMonster(tp,43990974,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c43990974.setfilter(c,chk)
	return aux.IsCodeListed(c,43990987) and c:GetType()==TYPE_TRAP and not c:IsCode(43990974) and c:IsFaceupEx() and c:IsSSetable() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c43990974.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990974.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0) end
end
function c43990974.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c43990974.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,1):GetFirst()
		if Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(43990974,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

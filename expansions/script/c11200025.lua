--『地上弹跳』
function c11200025.initial_effect(c)
--
	if not c11200025.global_check then
		c11200025.global_check=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAINING)
		e0:SetCondition(c11200025.con0)
		e0:SetOperation(c11200025.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200025+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11200025.cost1)
	e1:SetTarget(c11200025.tg1)
	e1:SetOperation(c11200025.op1)
	c:RegisterEffect(e1)
--
end
--
c11200025.xig_ihs_0x132=1
--
function c11200025.con0(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
		and not (rc.xig_ihs_0x132 or rc:IsCode(11200019))
end
--
function c11200025.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,11200025,RESET_PHASE+PHASE_END,0,1)
end
--
function c11200025.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoHand(sg,nil,REASON_COST)
end
--
function c11200025.tfilter1(c,e,tp)
	return c.xig_ihs_0x132 and c:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
end
function c11200025.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11200025.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
end
--
function c11200025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11200025.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if Duel.GetFlagEffect(tp,11200025)<1 and Duel.GetMZoneCount(tp)>1
		and Duel.SelectYesNo(tp,aux.Stringid(11200025,0)) then
		sg:AddCard(c)
	end
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			sc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
			Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
--

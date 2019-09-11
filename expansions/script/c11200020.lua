--月上的逃兵 铃仙·优昙华院·因幡
function c11200020.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11200020)
	e1:SetCost(c11200020.cost1)
	e1:SetTarget(c11200020.tg1)
	e1:SetOperation(c11200020.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200020,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCondition(c11200020.con2)
	e2:SetCost(c11200020.cost2)
	e2:SetOperation(c11200020.op2)
	c:RegisterEffect(e2)
--
end
--
c11200020.xig_ihs_0x132=1
--
function c11200020.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
--
function c11200020.tfilter1(c,e,tp)
	return c.xig_ihs_0x132 and c:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
end
function c11200020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc>0 and dc<4 then
		if Duel.GetMZoneCount(tp)<1 then return end
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if dc==4 then Duel.Damage(tp,1100,REASON_EFFECT) end
	if dc>4 then
		if Duel.GetMZoneCount(tp)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c11200020.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetCount()<1 then return end
		local tc=sg:GetFirst()
		tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
--
function c11200020.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
--
function c11200020.cfilter2(c)
	return c:IsAbleToRemoveAsCost()
		and c:IsType(TYPE_SPELL) and c.xig_ihs_0x132
end
function c11200020.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		and Duel.IsExistingMatchingCard(c11200020.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c11200020.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.Release(c,REASON_COST)
end
--
function c11200020.op2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
--

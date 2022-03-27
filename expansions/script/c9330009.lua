--陷阵营军
function c9330009.initial_effect(c)
	aux.AddCodeList(c,9330001,9330009)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9330009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9330009+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9330009.target)
	e1:SetOperation(c9330009.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c9330009.actcon)
	c:RegisterEffect(e0)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c9330009.atkcon)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--set/to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(aux.exccon)
	e4:SetCountLimit(1,9330009+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c9330009.thcost)
	e4:SetTarget(c9330009.settg)
	e4:SetOperation(c9330009.setop)
	c:RegisterEffect(e4)
end
function c9330009.actcon(e,tp,eg,ep,ev,re,r,rp)
	local  k=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(k,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(k,LOCATION_ONFIELD,0)
end
function c9330009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,9330009,0xaf93,0x21,3000,1500,6,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9330009.filter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330009.filter1(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c9330009.synfilter(c,mg)
	return c:IsLevel(12) and c:IsSynchroSummonable(nil,mg)
end
function c9330009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,9330009,0xaf93,0x21,3000,1500,6,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c9330009.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c9330009.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9330009,2)) then
		Duel.BreakEffect()
			c:RegisterFlagEffect(62899696,RESET_EVENT+RESETS_STANDARD,0,1)  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e1,tp)
			local mg=Duel.GetMatchingGroup(c9330009.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			local syng=Duel.GetMatchingGroup(c9330009.synfilter,tp,LOCATION_EXTRA,0,nil,mg)
			if syng:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local syn=syng:Select(tp,1,1,nil):GetFirst()
				Duel.SynchroSummon(tp,syn,nil,mg)
			end
	end
end
function c9330009.atkcon(e)
	return not Duel.IsExistingMatchingCard(c9330009.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9330009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330009.setfilter(c)
	if not (c:IsSetCard(0xaf93) and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsCode(9330009)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9330009.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330009.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9330009.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330009.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end












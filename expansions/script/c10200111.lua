--幻叙·魔法少女召集令
function c10200111.initial_effect(c)
	-- 卡组检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200111,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10200111)
	e1:SetCondition(c10200111.con1)
	e1:SetCost(c10200111.cost1)
	e1:SetTarget(c10200111.tg1)
	e1:SetOperation(c10200111.activate1)
	c:RegisterEffect(e1)
	-- 墓地代破
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200111,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10200112)
	e2:SetTarget(c10200111.tg2)
	e2:SetValue(c10200111.val2)
	e2:SetOperation(c10200111.op2)
	c:RegisterEffect(e2)
end
--
function c10200111.filter1(c)
	return c:IsSetCard(0x838) and c:IsRace(RACE_SPELLCASTER)
end
-- 1
function c10200111.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10200111.filter1,tp,LOCATION_HAND,0,nil)
	e:SetLabel(g:GetCount())
	return true
end
function c10200111.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c10200111.filter1,tp,LOCATION_HAND,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(10200111,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		e:SetLabel(1)
	end
end
function c10200111.filter11(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
		and not c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c10200111.filter111(c,e,tp)
	return c:IsSetCard(0x838) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200111.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rev=e:GetLabel()
	if chk==0 then
		if rev==1 then
			return Duel.IsExistingMatchingCard(c10200111.filter11,tp,LOCATION_DECK,0,1,nil)
				or Duel.IsExistingMatchingCard(c10200111.filter111,tp,LOCATION_DECK,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c10200111.filter11,tp,LOCATION_DECK,0,1,nil)
		end
	end
	if rev==1 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10200111.activate1(e,tp,eg,ep,ev,re,r,rp)
	local rev=e:GetLabel()
	if rev==1 and Duel.IsExistingMatchingCard(c10200111.filter111,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(10200111,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10200111.filter111,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,t,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c10200111.filter11,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,tc)
				local code=tc:GetOriginalCode()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
				e1:SetTarget(c10200111.tg11)
				e1:SetValue(RACE_SPELLCASTER)
				e1:SetLabel(code)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c10200111.tg11(e,c)
	return c:IsCode(e:GetLabel())
end
-- 2
function c10200111.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x838) and c:IsRace(RACE_SPELLCASTER)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c10200111.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c10200111.filter2,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c10200111.val2(e,c)
	return c10200111.filter2(c,e:GetHandlerPlayer())
end
function c10200111.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

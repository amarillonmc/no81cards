--深空 火
function c72101218.initial_effect(c)

	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101218,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,72101218)
	e1:SetCost(c72101218.cost1)
	e1:SetTarget(c72101218.settg)
	e1:SetOperation(c72101218.setop)
	c:RegisterEffect(e1)

	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101218,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,72101219)
	e2:SetCost(c72101218.cost2)
	e2:SetTarget(c72101218.thtg)
	e2:SetOperation(c72101218.thop)
	c:RegisterEffect(e2)

	--spsummon from szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101218,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,72101220)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCondition(c72101218.spcon)
	e3:SetTarget(c72101218.sptg)
	e3:SetOperation(c72101218.spop)
	c:RegisterEffect(e3)

end

--to field
function c72101218.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c72101218.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c72101218.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end

--to hand
function c72101218.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c72101218.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c72101218.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101218.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72101218.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72101218.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsSetCard(0xcea) then
				Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
		end
	end
end

--spsummon from szone
function c72101218.desfilter(c,tp)
	return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD+LOCATION_HAND,0,1,c)
end
function c72101218.dfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c72101218.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsFaceup()
end
function c72101218.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,72101218,0xcea,TYPE_MONSTER+TYPE_EFFECT,2100,0,4,RACE_PYRO,ATTRIBUTE_FIRE) 
	and Duel.IsExistingMatchingCard(c72101218.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)  end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72101218.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c72101218.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if #g1==0 then return end
	Duel.HintSelection(g1)
	local tc=g1:GetFirst()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsRace(RACE_PLANT) 
		and tc:IsAttribute(ATTRIBUTE_EARTH) and tc:IsType(TYPE_MONSTER) then
			if Duel.IsExistingMatchingCard(c72101218.dfilter,tp,LOCATION_MZONE,0,1,nil) then
				Duel.Damage(1-tp,500,REASON_EFFECT)
				else Duel.Damage(tp,500,REASON_EFFECT)
			end
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
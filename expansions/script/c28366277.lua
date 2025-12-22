--堕天的古之妖 漆黑幻想颂
function c28366277.initial_effect(c)
	--same effect send this card to grave and summon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28366277.cost)
	e1:SetTarget(c28366277.target)
	e1:SetOperation(c28366277.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28366277,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MSET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetLabelObject(e0)
	--e2:SetCondition(c28366277.spcon)
	e2:SetTarget(c28366277.sptg)
	e2:SetOperation(c28366277.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_CHANGE_POS)
	e4:SetCondition(c28366277.spcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c28366277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28366277.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28366277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366277.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28366277.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28366277.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(Group.FromCards(tc)) end
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end
		if tc:IsPreviousLocation(LOCATION_DECK) then Duel.ConfirmCards(1-tp,tc) end
		if not tc:IsLocation(LOCATION_HAND) then return end
		if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(c28366277.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28366277,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28366277.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetFirst():IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g) end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			if not g:GetFirst():IsLocation(LOCATION_HAND) then return end
			if g:GetFirst():IsPreviousLocation(LOCATION_DECK) then Duel.ConfirmCards(1-tp,g) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
			if dg:GetFirst():IsLocation(LOCATION_ONFIELD) then
				Duel.HintSelection(dg)
			end
			Duel.Destroy(dg,REASON_EFFECT)
		elseif Duel.GetLP(tp)>3000 then
			Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end
function c28366277.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)--Duel.GetLP(tp)<=3000
end
function c28366277.desfilter(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(1) and Duel.IsPlayerCanSpecialSummonMonster(tp,28366277,0x285,TYPES_NORMAL_TRAP_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),RACE_FIEND,c:GetAttribute()) and c:IsFaceup()
end
function c28366277.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c28366277.desfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28366277.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c28366277.desfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local atk,def,lv,attr=tc:GetAttack(),tc:GetDefense(),tc:GetLevel(),tc:GetAttribute()
	if Duel.Destroy(tc,REASON_EFFECT)==0 or Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,28366277,0x285,TYPES_NORMAL_TRAP_MONSTER,atk,def,lv,RACE_FIEND,attr) then
		Duel.BreakEffect()
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(lv)
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(attr)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e5:SetValue(LOCATION_REMOVED)
		--c:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end

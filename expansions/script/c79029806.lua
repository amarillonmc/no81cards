--逆元构造 乱数
function c79029806.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,2,nil,nil,99)
	c:EnableReviveLimit() 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029806,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029806)
	e1:SetCondition(c79029806.thcon)
	e1:SetTarget(c79029806.thtg)
	e1:SetOperation(c79029806.thop)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c79029806.xyzcon)
	e2:SetTarget(c79029806.xyztg)
	e2:SetOperation(c79029806.xyzop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,19029806)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029806.discon)
	e3:SetCost(c79029806.discost)
	e3:SetTarget(c79029806.distg)
	e3:SetOperation(c79029806.disop)
	c:RegisterEffect(e3)
end
function c79029806.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029806.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(3)
		and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c79029806.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c79029806.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c79029806.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c79029806.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		--local bool_a=tc:IsAbleToGrave()
		--local bool_b=tc:IsAbleToHand()
		--local op=2
		--if bool_a and bool_b then
		--	op=Duel.SelectOption(tp,aux.Stringid(79029806,2),aux.Stringid(79029806,3))
		--elseif bool_a then
		--	op=Duel.SelectOption(tp,aux.Stringid(79029806,2))
		--elseif bool_b then
		--	op=Duel.SelectOption(tp,aux.Stringid(79029806,3))+1
		--end
		--if op==0 then
		--	Duel.SendtoHand(tc,tp,REASON_EFFECT)
		--	Duel.ConfirmCards(1-tp,tc)  
		--elseif op==1 then
		--	Duel.SendtoGrave(tc,REASON_EFFECT)
		--else
		--end
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c79029806.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029806.aclimit1(e,re,tp)
	local tc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not (tc:IsLevelBelow(3) or tc:IsRankBelow(3) or tc:IsLinkBelow(3))
end
function c79029806.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c79029806.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c79029806.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
		if not c:GetOverlayGroup():IsContains(tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.ChainAttack()
	end
end
function c79029806.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c79029806.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c79029806.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029806.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
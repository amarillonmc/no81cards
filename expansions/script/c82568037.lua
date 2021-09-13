--AK-破邪的嵯峨
function c82568037.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c82568037.ovfilter,aux.Stringid(82568037,0))
	c:EnableReviveLimit()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82568037)
	e2:SetCost(c82568037.cost)
	e2:SetCondition(c82568037.con)
	e2:SetOperation(c82568037.operation)
	c:RegisterEffect(e2)
	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82568137)
	e4:SetCost(c82568037.thcost)
	e4:SetTarget(c82568037.thtg)
	e4:SetOperation(c82568037.thop)
	c:RegisterEffect(e4)
end
function c82568037.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825) and c:IsType(TYPE_LINK) and c:IsLinkAbove(2) 
end
function c82568037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82568037.con(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil)
end
function c82568037.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() 
		then
	if Duel.NegateAttack()~=0
	 then
		Duel.BreakEffect()
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e4)
		local e3=Effect.CreateEffect(c)
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  bc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
				  e2:SetType(EFFECT_TYPE_SINGLE)
				  e2:SetCode(EFFECT_SET_ATTACK_FINAL)
				  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  e2:SetValue(0)
				  bc:RegisterEffect(e2) 
	if Duel.SelectYesNo(tp,aux.Stringid(82568037,1)) then
	if Duel.SelectYesNo(tp,aux.Stringid(82568037,2)) and bc:IsLocation(LOCATION_MZONE) then
	   bc:AddCounter(0x5825,1)
	else c:AddCounter(0x5825,1)
	end
	end
	end
	end
end
function c82568037.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,0,1,0x5825,1,REASON_COST) or e:GetHandler():IsCanRemoveCounter(tp,0x5825,1,REASON_COST) end
	if Duel.IsCanRemoveCounter(tp,0,1,0x5825,1,REASON_COST) then
	   if not e:GetHandler():IsCanRemoveCounter(tp,0x5825,1,REASON_COST) then
	   Duel.RemoveCounter(tp,0,1,0x5825,1,REASON_COST)
	   else if Duel.SelectYesNo(tp,aux.Stringid(82568037,3)) then 
	   Duel.RemoveCounter(tp,0,1,0x5825,1,REASON_COST)
			else e:GetHandler():RemoveCounter(tp,0x5825,1,REASON_COST)
	   end
	   end
	else e:GetHandler():RemoveCounter(tp,0x5825,1,REASON_COST)
	end
end
function c82568037.filter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER) and 
			 c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsLevelBelow(6)
end
function c82568037.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82568037.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_DECK)
end
function c82568037.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568037.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc = g:GetFirst()
	Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
end
end
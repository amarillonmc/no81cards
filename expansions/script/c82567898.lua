--42星万能工程师 可露希尔
function c82567898.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(82567898,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567898)
	e1:SetCost(c82567898.cost)
	e1:SetTarget(c82567898.target1)
	e1:SetOperation(c82567898.activate1)
	c:RegisterEffect(e1)
	--activate to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567898,2))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,82567898)
	e2:SetCost(c82567898.cost)
	e2:SetTarget(c82567898.target2)
	e2:SetOperation(c82567898.activate2)
	c:RegisterEffect(e2)
	--tohand 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(82567898,3))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,82567898)
	e3:SetCost(c82567898.cost)
	e3:SetTarget(c82567898.target3)
	e3:SetOperation(c82567898.activate3)
	c:RegisterEffect(e3)
	--Activate counter
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetDescription(aux.Stringid(82567898,5))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,82567898)
	e5:SetCost(c82567898.cost)
	e5:SetTarget(c82567898.target5)
	e5:SetOperation(c82567898.activate5)
	c:RegisterEffect(e5)
end
function c82567898.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c82567898.spfilter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c82567898.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,82567898,0x825,0x11,1300,1000,3,RACE_ZOMBIE,ATTRIBUTE_DARK)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c82567898.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,82567898,0x825,0x11,1300,1000,3,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER) 
	   Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c82567898.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(82567898,1)) then
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567898.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
end
end
end
function c82567898.tgfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c82567898.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567898.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c82567898.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c82567898.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c82567898.thfilter(c)
	return c:IsSetCard(0x825) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand() and not c:IsCode(82567898)
end
function c82567898.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567898.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c82567898.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567898.thfilter),tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82567898.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82567898.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567898.mfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c82567898.activate4(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567898.mfilter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
   local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c82567898.efilter)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e5)
	tc=sg:GetNext()
	end
end
function c82567898.ctfilter(c)
	return c:IsFaceup() 
end
function c82567898.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82567898.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567898.ctfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0x5825,2)
end
function c82567898.activate5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c82567898.ctfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc:IsFaceup() and tc:IsControler(tp) 
  then  tc:AddCounter(0x5825,3)
	end
end
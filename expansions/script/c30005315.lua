--划谋之魔
local m=30005315
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_SUMMON+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_SZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	--e51:SetCountLimit(1)
	e51:SetCost(cm.cost)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)   
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--Effect 3
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCost(aux.bfgcost)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.gtg)
	e5:SetOperation(cm.gop)
	c:RegisterEffect(e5)	
end
--Effect 1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.th(c)
	local b1=c:IsLocation(LOCATION_DECK) and c:IsAttack(2700) and c:IsDefense(1000)
	local b2=c:IsLocation(LOCATION_GRAVE) and  c:IsLevel(6)
	return c:IsRace(RACE_FIEND) and (b1 or b2) and c:IsAbleToHand()
end
function cm.suf(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(6) and c:IsSummonable(true,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return #kg>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.th),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #kg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	local gc=kg:Select(tp,1,1,nil):GetFirst()
	if gc==nil or not gc then return false end
	if Duel.SendtoHand(gc,nil,REASON_EFFECT)==0 or gc:GetLocation()~=LOCATION_HAND then return false end
	Duel.ConfirmCards(1-tp,gc)
	Duel.ShuffleHand(tp)
	local sg=Duel.GetMatchingGroup(cm.suf,tp,LOCATION_HAND,0,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.suf,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if not tc or tc==nil then return false end
		Duel.Summon(tp,tc,true,nil)
	end
end  
--Effect 2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,2700,1000,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,2700,1000,6,RACE_FIEND,ATTRIBUTE_DARK) or not c:IsRelateToEffect(e) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local a=Duel.GetAttacker()
		if c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e11=Effect.CreateEffect(c)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e11:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e11:SetValue(LOCATION_DECK)
			c:RegisterEffect(e11)
		end
		if a:IsAttackable() and not a:IsImmuneToEffect(e) then
			Duel.CalculateDamage(a,c)
		end
	end
end
--Effect 3
function cm.ch(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function cm.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ch,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ch,tp,LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,#g,nil)
	if #tg==0 then return false end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
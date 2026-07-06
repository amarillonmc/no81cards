--幻梦§继承 夜刀浦罗
local m=14002322
local cm=_G["c"..m]
cm.named_with_Urara=1
function cm.initial_effect(c)
	--link
	aux.AddLinkProcedure(c,nil,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--spsummon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(2,m)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	e2:SetLabel(14002381)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(2,m)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.matfilter,1,nil)
end
function cm.matfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function cm.atkcon(e)
	local c=e:GetHandler()
	if not Duel.GetAttacker() then return end
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
		if g:GetCount()==0 then return false end
		local g1,atk=g:GetMaxGroup(Card.GetBaseAttack)
		return not c:IsAttack(atk)
	end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
	if g:GetCount()==0 then return end
	local g1,atk=g:GetMaxGroup(Card.GetBaseAttack)
	if c:IsFaceup() and atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
function cm.tdfilter(c)
	return cm.Hastur(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.thfilter1(c,tp)
	return cm.Hastur(c) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function cm.thfilter2(c)
	return cm.Urara(c) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,14002381,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_AQUA,ATTRIBUTE_WATER)
	local b2=Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,14002381,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_AQUA,ATTRIBUTE_WATER)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,3))+1
	else return end
	if op==0 then
		local token=Duel.CreateToken(tp,14002381)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	elseif op==1 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
		if #g1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,sg1:GetFirst())
			sg1:Merge(sg2)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
		end
	end
end
function cm.ctfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local xg=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=1
	if #xg>1 then ct=2 end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1402,ct)
	end
end
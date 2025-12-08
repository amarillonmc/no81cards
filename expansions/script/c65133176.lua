--幻叙同位体 螟灵「机械学徒」
local s,id,o=GetID()
function s.initial_effect(c)
	--Effect 1: Summon & Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.sumcost)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	--Effect 2: Gain Effects
	--Shared HOPT for activated effects (Bullet 1, 2, 4, 6)
	--Bullet 1: ATK Up (Level 1+)
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,1))
	e2a:SetCategory(CATEGORY_ATKCHANGE)
	e2a:SetType(EFFECT_TYPE_IGNITION)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2a:SetCountLimit(1,id+o)
	e2a:SetCondition(s.effcon(1))
	e2a:SetTarget(s.atktg)
	e2a:SetOperation(s.atkop)
	c:RegisterEffect(e2a)
	--Bullet 2: Deck Dump & Bounce (Level 4+)
	local e2b=Effect.CreateEffect(c)
	e2b:SetDescription(aux.Stringid(id,2))
	e2b:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2b:SetType(EFFECT_TYPE_IGNITION)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetCountLimit(1,id+o)
	e2b:SetCondition(s.effcon(4))
	e2b:SetCost(s.thcost)
	e2b:SetTarget(s.thtg)
	e2b:SetOperation(s.thop)
	c:RegisterEffect(e2b)
	--Bullet 3: Untargetable & ATK (Level 6+)
	local e2c=Effect.CreateEffect(c)
	e2c:SetType(EFFECT_TYPE_SINGLE)
	e2c:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2c:SetRange(LOCATION_MZONE)
	e2c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2c:SetCondition(s.effcon(6))
	e2c:SetValue(aux.tgoval)
	c:RegisterEffect(e2c)
	local e2c2=e2c:Clone()
	e2c2:SetCode(EFFECT_UPDATE_ATTACK)
	e2c2:SetValue(1200)
	c:RegisterEffect(e2c2)
	--Bullet 4: Destroy (Level 8+)
	local e2d=Effect.CreateEffect(c)
	e2d:SetDescription(aux.Stringid(id,3))
	e2d:SetCategory(CATEGORY_DESTROY)
	e2d:SetType(EFFECT_TYPE_QUICK_O)
	e2d:SetCode(EVENT_CHAINING)
	e2d:SetRange(LOCATION_MZONE)
	e2d:SetCountLimit(1,id+o)
	e2d:SetCondition(s.descon)
	e2d:SetTarget(s.destg)
	e2d:SetOperation(s.desop)
	c:RegisterEffect(e2d)
	--Bullet 5: Unaffected (Level 10+)
	local e2e=Effect.CreateEffect(c)
	e2e:SetType(EFFECT_TYPE_SINGLE)
	e2e:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2e:SetRange(LOCATION_MZONE)
	e2e:SetCode(EFFECT_IMMUNE_EFFECT)
	e2e:SetCondition(s.effcon(10))
	e2e:SetValue(s.efilter)
	c:RegisterEffect(e2e)
	--Bullet 6: Negate & Copy (Level 12+)
	local e2f=Effect.CreateEffect(c)
	e2f:SetDescription(aux.Stringid(id,4))
	e2f:SetCategory(CATEGORY_DISABLE)
	e2f:SetType(EFFECT_TYPE_QUICK_O)
	e2f:SetCode(EVENT_CHAINING)
	e2f:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2f:SetRange(LOCATION_MZONE)
	e2f:SetCountLimit(1,id+o)
	e2f:SetCondition(s.cpcon)
	e2f:SetTarget(s.cptg)
	e2f:SetOperation(s.cpop)
	c:RegisterEffect(e2f)
end
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local f1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return (h1+f1)<=(h2-1)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x838,TYPES_TOKEN+TYPE_MONSTER,1500,1500,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		if Duel.Summon(tp,c,true,nil)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
				or not Duel.IsPlayerCanSpecialSummonMonster(tp,12345678,0x838,TYPES_TOKEN+TYPE_MONSTER,1500,1500,4,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,12345678)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.get_max(c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c)
	local max=0
	for tc in aux.Next(g) do
		local lv=tc:GetLevel()
		local rk=tc:GetRank()
		if lv>max then max=lv end
		if rk>max then max=rk end
	end
	return max
end
function s.effcon(lim)
	return function(e)
		return s.get_max(e:GetHandler())>=lim
	end
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x838)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.tgfilter(c)
	return c:IsSetCard(0x838) and c:IsAbleToGrave()
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x838) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g2>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
		end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and s.get_max(e:GetHandler())>=8
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOnField() 
		and s.get_max(e:GetHandler())>=12
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=re:GetHandler()
	if chkc then return chkc==rc end
	if chk==0 then return rc:IsOnField() and rc:IsCanBeEffectTarget(e) and not rc:IsDisabled() end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,rc,1,0,0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if c:IsRelateToChain() and c:IsFaceup() then
			c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		end
	end
end

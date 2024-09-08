--制衡之魔
local m=30005316
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.chcon)
	e3:SetOperation(cm.chop)
	c:RegisterEffect(e3)
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
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	--e3:SetCountLimit(1,m+m)
	e3:SetCondition(cm.tcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.sf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.sf,tp,LOCATION_ONFIELD,0,nil)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and #g>0
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.sf,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		--Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--Effect 2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1000,2700,6,RACE_FIEND,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(95440946)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1000,2700,6,RACE_FIEND,ATTRIBUTE_WATER) or not c:IsRelateToEffect(e) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if  Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
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
function cm.thcf(c,tp,rp)
	local b1=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b2=bit.band(c:GetPreviousRaceOnField(),RACE_FIEND)~=0 
	local b3=c:GetReasonPlayer()==1-tp
	return c:IsPreviousControler(tp) and (b1 or b2) and b3 
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcf,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end 
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local gt=eg:FilterCount(cm.thcf,nil,tp,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if chk==0 then return #tg>=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,gt,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local gt=eg:FilterCount(cm.thcf,nil,tp,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if gt==0 or #tg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=tg:Select(tp,gt,gt,nil)
	if #dg==0 then return false end
	Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

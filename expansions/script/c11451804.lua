--烈焰加农炮-自走式
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCondition(cm.spcon)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetValue(33365932)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetTarget(cm.chtg)
	e3:SetValue(33365932)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetOwner()
	if rc:GetOriginalCode()==33365932 then
		re:SetOperation(cm.replaceop)
	end
end
function cm.thfilter(c)
	return c:IsCode(33365932) and c:IsAbleToHand()
end
function cm.replaceop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.spfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,3,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,3,3,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.chtg(e,c)
	if c then return c:IsRace(RACE_PYRO) and c:IsType(TYPE_MONSTER) end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return (re:GetCode()==EVENT_SUMMON_SUCCESS or re:GetCode()==EVENT_SPSUMMON_SUCCESS) or (re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.filter(c)
	return c:IsCode(33365932) and c:IsAttackBelow(500) --and c:IsType(TYPE_MONSTER)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,Group.FromCards(c,rc))
	if chk==0 then return rc:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and rc:IsDestructable() and rc:IsRelateToEffect(re) and #g>0 and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local loc=(LOCATION_DECK&(c:GetLocation()))&(rc:GetLocation())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,3,0,loc)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,Group.FromCards(c,rc))
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and rc:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=g:Select(tp,1,1,nil)
		if #tg>0 then
			tg:AddCard(c)
			tg:AddCard(rc)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
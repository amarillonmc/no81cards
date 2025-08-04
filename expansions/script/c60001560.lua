--雷火双神·福尼加尔&亚文哈尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableCounterPermit(0x624)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73539069,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD)
	c:RegisterEffect(e2)

	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)   
	local ee3=Effect.CreateEffect(c)
	ee3:SetDescription(aux.Stringid(74997493,0))
	ee3:SetCategory(CATEGORY_COUNTER)
	ee3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ee3:SetProperty(EFFECT_FLAG_DELAY)
	ee3:SetCode(EVENT_SUMMON_SUCCESS)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetCondition(cm.atkcon)
	ee3:SetOperation(cm.atkop)
	c:RegisterEffect(ee3)
	local ee4=ee3:Clone()
	ee4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ee4)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local f=Duel.GetFlagEffect(tp,60002148)
	if f<5 then
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,5-f,e:GetHandler()) end
		Duel.DiscardHand(tp,Card.IsDiscardable,5-f,5-f,REASON_COST+REASON_DISCARD)
	elseif f==5 then
		if chk==0 then return true end
	elseif f>5 then
		if chk==0 then return Duel.IsPlayerCanDraw(tp,f-5) end
		Duel.Draw(tp,f-5,REASON_COST)
	end
end
function cm.filter(c)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if c:IsLocation(LOCATION_MZONE) then
			e:GetHandler():AddCounter(0x624,1)
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.cfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsCanAddCounter(0x624,1)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(cm.cfilter,1,nil,lg)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if not lg then return end
	local g=eg:Filter(cm.cfilter,nil,lg)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		tc=g:GetNext()
	end
end
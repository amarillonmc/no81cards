--邪骨团 聚义厅
local m=64800141
local cm=_G["c"..m]
Duel.LoadScript("c64800135.lua")
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.val1)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetValue(cm.val2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.drcost)
	e4:SetTarget(cm.tg2)
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
end
cm.setname="Zx02"
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	if Duel.CheckLPCost(tp,1000) and (not Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cm.thfilter(c)
	return c.setname=="Zx02" and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and bit.band(TYPE_MONSTER,c:GetOriginalType())~=0 
end
function cm.reptg(e,c)
	local res=Duel.GetMatchingGroupCount(cm.thfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	return c.setname=="Zx02" and c:IsLevelBelow(4) and res>0
end
function cm.val1(e)
	local g=Duel.GetMatchingGroup(cm.thfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	local tc=g:GetMaxGroup(Card.GetOriginalLevel):GetFirst()
	return tc:GetBaseAttack()
end
function cm.val2(e)
	local g=Duel.GetMatchingGroup(cm.thfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	local tc=g:GetMaxGroup(Card.GetOriginalLevel):GetFirst()
	return tc:GetBaseDefense()
end

function cm.tfilter2(c)
	return c:IsAbleToHand() or c:IsAbleToGrave()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tfilter2,tp,LOCATION_DECK,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,4) then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	local sg=g:Filter(cm.thfilter1,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local zg=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(zg,nil,REASON_EFFECT)
		g:Sub(zg)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.thfilter1(c)
	return c.setname=="Zx02" and c:IsType(TYPE_MONSTER)
end
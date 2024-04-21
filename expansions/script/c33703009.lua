--愉快军火竞赛
local m=33703009
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCondition(cm.ccon)
	c:RegisterEffect(e2)
	--Effect 2  
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
--Effect 1
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local pp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(pp,LOCATION_ONFIELD,0)>0
end 
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
	local pp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(1-pp,LOCATION_ONFIELD,0)>0
end 
function cm.sf(c) 
	local chk
	if c:IsLocation(LOCATION_HAND) then 
		chk=c:IsPublic()
	else
		chk=c:IsFaceup()
	end
	return c:GetCode()~=m and chk
end  
function cm.th(c,tp)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.ff,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,1,nil,c:GetCode())
end
function cm.ff(c,code)
	return cm.sf(c) and c:IsCode(code)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.th),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=g:Select(tp,1,1,nil)
	local thc=thg:GetFirst()
	if thc==nil or not thc then return false end
	if Duel.SendtoHand(thc,nil,REASON_EFFECT)==0 or thc:GetLocation()~=LOCATION_HAND then return false end
	Duel.ConfirmCards(1-tp,thc)
	local exchk=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
	if exchk and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 
			and Duel.IsPlayerCanDraw(1-tp,1) then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	else
		if Duel.IsPlayerCanDraw(1-tp,1) then 
			Duel.Draw(1-tp,1,REASON_EFFECT) 
		end
	end
end
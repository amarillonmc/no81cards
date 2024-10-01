--命运从未公平
function c60010130.initial_effect(c)
	aux.AddCodeList(c,60010051)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010130.condition)
	e0:SetOperation(c60010130.activate)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(60010130)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010130)
	e2:SetCondition(c60010130.decon)
	e2:SetTarget(c60010130.detg)
	e2:SetOperation(c60010130.deop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010130.checkop)
	c:RegisterEffect(e3)
c60010130.toss_dice=true
c60010130.toss_coin=true
end
function c60010130.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not SpaceCheck then
		SpaceCheck={}
		for i=0,1 do
			local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
			if #g==g:GetClassCount(Card.GetCode) then
				SpaceCheck[i]=true
			end
		end
	end
end
function c60010130.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010130.thfilter(c)
	return c:IsCode(60010051) and c:IsAbleToHand()
end
function c60010130.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010130.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010130,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010130.ownerfilter(c,tp)
	return c:IsCode(60010051) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010130.decon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010130.ownerfilter,1,nil,tp)
end
function c60010130.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,ct)
end
function c60010130.deop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct==0 then return end
	local count=0
	for i=1,ct do
		local dice=Duel.TossDice(tp,1)
		if dice==5 or dice==6 then
			count=count+1
		end
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,count,count,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	else
		local dg=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,count)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

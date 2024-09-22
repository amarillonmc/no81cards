--驶向第二次生命
function c60010134.initial_effect(c)
	aux.AddCodeList(c,60010077)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010134.condition)
	e0:SetOperation(c60010134.activate)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(60010134)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010134)
	e2:SetCondition(c60010134.drcon)
	e2:SetTarget(c60010134.drtg)
	e2:SetOperation(c60010134.drop)
	c:RegisterEffect(e2)
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
function c60010134.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010134.thfilter(c)
	return c:IsCode(60010077) and c:IsAbleToHand()
end
function c60010134.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010134.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010134,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010134.ownerfilter(c,tp)
	return c:IsCode(60010077) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010134.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010134.ownerfilter,1,nil,tp)
end
function c60010134.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c60010134.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

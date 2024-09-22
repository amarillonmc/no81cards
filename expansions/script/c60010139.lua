--片刻，留在眼底
function c60010139.initial_effect(c)
	aux.AddCodeList(c,60010078)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010139.condition)
	e0:SetOperation(c60010139.activate)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(60010139)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010139)
	e2:SetCondition(c60010139.drcon)
	e2:SetTarget(c60010139.drtg)
	e2:SetOperation(c60010139.drop)
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
function c60010139.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010139.thfilter(c)
	return c:IsCode(60010078) and c:IsAbleToHand()
end
function c60010139.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010139.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010139,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010139.ownerfilter(c,tp)
	return c:IsCode(60010078) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010139.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010139.ownerfilter,1,nil,tp)
end
function c60010139.cfilter(c)
	return Duel.IsPlayerCanDraw(c:GetControler())
end
function c60010139.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60010139.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c60010139.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c60010139.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		g=Duel.GetOperatedGroup()
		local d1=0
		local d2=0
		for tc in aux.Next(g) do
			if tc then
				if tc:IsPreviousControler(0) then d1=d1+1
				else d2=d2+1 end
			end
		end
		Duel.Draw(0,d1,REASON_EFFECT)
		Duel.Draw(1,d2,REASON_EFFECT)
	end
end

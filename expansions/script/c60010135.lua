--夜色流光溢彩
function c60010135.initial_effect(c)
	aux.AddCodeList(c,60010076,60010029)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010135.condition)
	e0:SetOperation(c60010135.activate)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(60010135)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010135)
	e2:SetCondition(c60010135.thcon)
	e2:SetTarget(c60010135.thtg)
	e2:SetOperation(c60010135.thop)
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
function c60010135.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010135.thfilter(c)
	return c:IsCode(60010076) and c:IsAbleToHand()
end
function c60010135.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010135.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010135,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010135.ownerfilter(c,tp)
	return c:IsCode(60010076) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010135.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010135.ownerfilter,1,nil,tp)
end
function c60010135.sefilter(c)
	return aux.IsCodeListed(c,60010029) and c:IsAbleToHand()
end
function c60010135.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60010135.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c60010135.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60010135.sefilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

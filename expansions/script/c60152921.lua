--爱与希望之歌
function c60152921.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,60152921+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60152921.e1con)
	e1:SetCost(c60152921.e1cost)
	e1:SetTarget(c60152921.e1tg)
	e1:SetOperation(c60152921.e1op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60152921.e2tg)
	e2:SetOperation(c60152921.e2op)
	c:RegisterEffect(e2)
end
function c60152921.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c60152921.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c60152921.cfilter(c,tp)
	return c:GetOriginalLevel()>0 and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c60152921.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c60152921.thfilter(c,tc)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x3b29)
		and c:GetOriginalLevel()<=tc:GetOriginalLevel()
		and c:IsAbleToHand()
end
function c60152921.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c60152921.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	end
	local g=Duel.SelectMatchingCard(tp,c60152921.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60152921.filter(c,tc)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x3b29) and c:GetOriginalLevel()>0
		and c:GetOriginalLevel()<tc:GetOriginalLevel()
		and c:IsAbleToHand()
end
function c60152921.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60152921.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc2=g:GetFirst()
		if Duel.GetMatchingGroup(c60152921.filter,tp,LOCATION_GRAVE,0,nil,tc2)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g3=Duel.SelectMatchingCard(tp,c60152921.filter,tp,LOCATION_GRAVE,0,1,1,nil,tc2)
			if g3:GetCount()>0 then
				Duel.SendtoHand(g3,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g3)
			end
		end
	end
end

function c60152921.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return true end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
end
function c60152921.e2op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
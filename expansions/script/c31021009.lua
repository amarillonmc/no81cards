--N#11 Antonymph Heavy Light
function c31021009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c31021009.lcheck)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c31021009.batfilter)
	c:RegisterEffect(e1)
	--protec
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c31021009.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--add to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1, 31012009)
	e4:SetTarget(c31021009.target)
	e4:SetOperation(c31021009.operation)
	c:RegisterEffect(e4)
end
function c31021009.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x893)
end

function c31021009.batfilter(e,c)
	return not c:IsSetCard(0x891)
end

function c31021009.indtg(e,tc)
	return e:GetHandler():GetLinkedGroup():IsContains(tc)
end

function c31021009.filter(c,e)
	return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c31021009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31021009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31021009.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c31021001.filter,tp,LOCATION_GRAVE,0,1,3,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c31021009.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		local og=sg:Filter(Card.IsLocation,nil,LOCATION_HAND):GetCount()
		if og>0 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,og,og,REASON_EFFECT,nil)
		end
	end
end
	
--星宫守护者·天秤
function c72412210.initial_effect(c)
	aux.AddCodeList(c,72412220)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412210,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412210)
	e1:SetTarget(c72412210.drcost)
	e1:SetTarget(c72412210.drtg)
	e1:SetOperation(c72412210.drop)
	c:RegisterEffect(e1)
			--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412211)
	e2:SetOperation(c72412210.regop)
	c:RegisterEffect(e2)
end
function c72412210.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c72412210.drfilter(c)
	return c:IsSetCard(0x9728) and c:IsAbleToGrave()
end
function c72412210.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412210.drfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and
	Duel.IsPlayerCanDraw(tp,2) 
		end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c72412210.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.SelectMatchingCard(tp,c72412210.drfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g~=0 then
		Group.AddCard(g,e:GetHandler())
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then   
		Duel.Draw(p,d,REASON_EFFECT)
		end
	end
end

function c72412210.thfilter1(c)
	return c:IsCode(72412220) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),72412340) and c:IsSetCard(0x9728))
end
function c72412210.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,72412210,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c72412210.thcon)
	e1:SetOperation(c72412210.thop)
	Duel.RegisterEffect(e1,tp)
end
function c72412210.thfilter2(c)
	return c72412210.thfilter1(c) and c:IsAbleToHand()
end
function c72412210.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c72412210.thfilter2),tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,72412210)==0
end
function c72412210.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412210)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72412210.thfilter2),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
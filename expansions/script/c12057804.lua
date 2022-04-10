--强者的邀约
function c12057804.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12057804)
	e1:SetCost(c12057804.accost)
	e1:SetTarget(c12057804.actg)
	e1:SetOperation(c12057804.acop)
	c:RegisterEffect(e1)
	--xx
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057804,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,22057804)
	e1:SetCondition(c12057804.xxcon)
	e1:SetTarget(c12057804.xxtg)
	e1:SetOperation(c12057804.xxop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c12057804.ctfil(c)
	return c:IsSetCard(0x145,0x16b) and (c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost())
end
function c12057804.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057804.ctfil,tp,LOCATION_DECK,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c12057804.ctfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	local op=3 
	local b1=tc:IsAbleToGraveAsCost() 
	local b2=tc:IsAbleToRemoveAsCost()
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057804,0),aux.Stringid(12057804,1)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057804,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057804,1))+1 
	end
	if op==0 then 
	Duel.SendtoGrave(tc,REASON_COST)
	elseif op==1 then 
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
end
function c12057804.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c12057804.acop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then 
	Duel.BreakEffect() 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c12057804.xxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp 
end
function c12057804.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c12057804.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(Duel.GetTurnCount()+1)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetCondition(c12057804.thcon)
			e1:SetOperation(c12057804.thop)
			Duel.RegisterEffect(e1,tp)
end
function c12057804.thfil(c)
	return c:IsCode(30680659,52947044) and c:IsAbleToHand()
end
function c12057804.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.IsExistingMatchingCard(c12057804.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
end
function c12057804.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,12057804) 
	local g=Duel.SelectMatchingCard(tp,c12057804.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	Duel.SendtoHand(g,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,g)
end















--企鹅物流·行动-战术快递
function c79029449.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029449)
	e1:SetTarget(c79029449.target)
	e1:SetOperation(c79029449.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetCondition(c79029449.recon)
	e2:SetOperation(c79029449.reop)
	c:RegisterEffect(e2)	
end
function c79029449.filter(c)
	return c:IsAbleToHand() and ( c:IsSetCard(0xa900) or c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d) )
end
function c79029449.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029449.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029449.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029449.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c79029449.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c79029449.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xc90e) and not re:GetHandler():IsSetCard(0xb90d) and not re:GetHandler():IsSetCard(0xa900) 
end
function c79029449.thfil(c)
	return c:IsAbleToHand() and (c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d))
end
function c79029449.ckfil(c)
	return c:IsSetCard(0xa900) or c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d)
end
function c79029449.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,79029449)==0
end
function c79029449.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,79029449,0,0,0)
	local b1=Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local b2=Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(c79029449.thfil,tp,LOCATION_DECK,0,1,nil)
	if Duel.GetMatchingGroupCount(c79029449.ckfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil)>=40 and Duel.SelectEffectYesNo(tp,c) then
	Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	if b1 then
	g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	x=Duel.SendtoDeck(g,tp,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,x,REASON_EFFECT) 
	elseif b2 then
	dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,2,2,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	sg=Duel.SelectMatchingCard(tp,c79029449.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end 
	end
end














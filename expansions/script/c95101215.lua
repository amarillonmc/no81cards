--智谋水樱之化龙
function c95101215.initial_effect(c)
	aux.AddMaterialCodeList(c,95101212)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunction(Card.IsCode,95101212),1)
	c:EnableReviveLimit()
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95101215.drcon1)
	e1:SetOperation(c95101215.drop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95101215.regcon)
	e2:SetOperation(c95101215.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95101215.drcon2)
	e3:SetOperation(c95101215.drop2)
	c:RegisterEffect(e3)
	--to hand(equip)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101215,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,95101215)
	e4:SetCondition(c95101215.thcon)
	e4:SetTarget(c95101215.thtg)
	e4:SetOperation(c95101215.thop)
	e4:SetLabel(0x1)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95101215,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,95101215)
	e5:SetCondition(c95101215.thcon2)
	e5:SetTarget(c95101215.thtg)
	e5:SetOperation(c95101215.thop)
	e5:SetLabel(0x6)
	c:RegisterEffect(e5)
end
function c95101215.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and not Duel.IsChainSolving() and not eg:IsContains(e:GetHandler())
end
function c95101215.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c95101215.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.IsChainSolving() and not eg:IsContains(e:GetHandler())
end
function c95101215.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,95101215,RESET_CHAIN,0,1)
end
function c95101215.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,95101215)>0
end
function c95101215.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,95101215)
	Duel.ResetFlagEffect(tp,95101215)
	Duel.Draw(tp,n,REASON_EFFECT)
end
function c95101215.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c95101215.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c95101215.thfilter(c,typ)
	return c:IsSetCard(0x5bb0) and c:IsType(typ) and c:IsAbleToHand()
end
function c95101215.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local typ=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c95101215.thfilter,tp,LOCATION_DECK,0,1,nil,typ) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101215.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95101215.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

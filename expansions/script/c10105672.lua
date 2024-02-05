function c10105672.initial_effect(c)
   --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105672,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10105672)
	e1:SetTarget(c10105672.thtg)
	e1:SetOperation(c10105672.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c10105672.effcon)
	e3:SetOperation(c10105672.effop)
	c:RegisterEffect(e3)
    end
function c10105672.thfilter(c)
	return c:IsSetCard(0x86) and c:IsAbleToHand()
end
function c10105672.rettfilter(c)
	return c:IsSetCard(0x86) and c:IsSummonable(true,nil)
end
function c10105672.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105672.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c10105672.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105672.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c10105672.rettfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(10105672,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c10105672.rettfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function c10105672.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():GetMaterial():IsExists(Card.IsPreviousLocation,3,nil,LOCATION_MZONE)
end
function c10105672.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10105672)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(10105672,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c10105672.rmcon)
	e1:SetTarget(c10105672.rmtg)
	e1:SetOperation(c10105672.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	end
function c10105672.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c10105672.filter(c)
	return c:IsAbleToRemove()
end
function c10105672.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c10105672.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10105672.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10105672.filter,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c10105672.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
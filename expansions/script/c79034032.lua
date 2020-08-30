--Hollow Knight-辐光娘
function c79034032.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	c:EnableReviveLimit()  
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79034032,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c79034032.thtg)
	e1:SetOperation(c79034032.thop)
	c:RegisterEffect(e1)  
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c79034032.reptg)
	e1:SetValue(c79034032.repval)
	e1:SetOperation(c79034032.repop)
	c:RegisterEffect(e1)   
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,79034032)
	e2:SetTarget(c79034032.bctg)
	e2:SetOperation(c79034032.bcop)
	c:RegisterEffect(e2)
end
function c79034032.cfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND) and c:IsSetCard(0xca9)
end
function c79034032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79034032.cfil,1,nil) end
end
function c79034032.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
end
end
function c79034032.repfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c79034032.rfil(c)
	return c:IsSetCard(0xca9) and c:IsAbleToGrave()
end
function c79034032.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034032.rfil,tp,LOCATION_HAND,0,1,nil) and eg:IsExists(c79034019.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c79034032.repval(e,c)
	return c79034032.repfilter(c,e:GetHandlerPlayer())
end
function c79034032.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c79034032.rfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,POS_FACEUP,REASON_EFFECT)
end
function c79034032.thfilter3(c)
	return c:IsSetCard(0xca9) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c79034032.bctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetReasonPlayer()~=tp and Duel.IsExistingMatchingCard(c79034032.thfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79034032.thfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,nil,tp,0)
end
function c79034032.bcop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end  



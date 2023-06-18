local m=34500360
local cm=_G["c"..m]
cm.name="黑金暴龙的巫女"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34500360,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,34500360)
	e1:SetCost(c34500360.cost)
	e1:SetTarget(c34500360.target1)
	e1:SetOperation(c34500360.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34500350,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,34500361)
	e2:SetCost(c34500360.cost)
	e2:SetOperation(c34500360.activate3)
	c:RegisterEffect(e2)
end
function c34500360.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEUP)==3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c34500360.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c34500360.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c34500360.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c34500360.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c34500360.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c34500360.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c34500360.splimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c34500360.splimit2(e,c)
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON))
end
function c34500360.activate3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c34500360.target4)
	e1:SetValue(c34500360.efilter4)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c34500360.target4(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	return (not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)
end
function c34500360.efilter4(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--满开神树勇者 牵牛
function c9910315.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910315.tgcost)
	e1:SetTarget(c9910315.tgtg)
	e1:SetOperation(c9910315.tgop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910315.negcon)
	e2:SetOperation(c9910315.negop)
	c:RegisterEffect(e2)
	--to extra
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910315.tecon)
	e3:SetTarget(c9910315.tetg)
	e3:SetOperation(c9910315.teop)
	c:RegisterEffect(e3)
end
function c9910315.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c9910315.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end
function c9910315.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9910315.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c9910315.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	return g and g:IsExists(c9910315.cfilter,1,nil) and rp==1-tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and c:GetFlagEffect(9910315)==0
end
function c9910315.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(9910315,0)) then
		Duel.Hint(HINT_CARD,0,9910315)
		Duel.NegateEffect(ev)
		c:RegisterFlagEffect(9910315,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910315,1))
	end
end
function c9910315.tecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910315.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c9910315.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_GRAVE))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

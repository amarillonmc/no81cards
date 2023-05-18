--元素灵剑士·黑暗
function c98920570.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920570.lcheck)
	c:EnableReviveLimit()
	--BP skip
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c98920570.regcon)
	e0:SetOperation(c98920570.regop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920570,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+98920570)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c98920570.skop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920570,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c98920570.thcon)
	e3:SetTarget(c98920570.thtg)
	e3:SetOperation(c98920570.thop)
	c:RegisterEffect(e3)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--change cost
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(61557074,1))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(61557074)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(c98920570.atlcon)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
end
function c98920570.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x400d,0x113)
end
function c98920570.atlcon(e)
	return e:GetHandler():GetSequence()>4
end
function c98920570.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:IsPreviousControler(1-tp) then seq=seq+16 end
	return c:IsSetCard(0x113) and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c98920570.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920570.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c98920570.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,98920570)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+98920570,e,0,tp,0,0)
end
function c98920570.skop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c98920570.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c98920570.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and not e:GetHandler():IsReason(REASON_RULE) and rp==1-tp
end
function c98920570.thfilter(c)
	return c:IsSetCard(0x113) and c:IsAbleToHand()
end
function c98920570.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920570.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920570.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920570.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--闪耀的港湾 283事务所
function c28333396.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c28333396.indescon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c28333396.rmlimit)
	e2:SetCondition(c28333396.indescon)
	c:RegisterEffect(e2)
	--defense
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c28333396.defcon)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--field to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(3)
	e4:SetTarget(c28333396.fthtg)
	e4:SetOperation(c28333396.fthop)
	c:RegisterEffect(e4)
	--grave to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28333396,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,28333396)
	e5:SetCondition(c28333396.gthcon1)
	e5:SetTarget(c28333396.gthtg)
	e5:SetOperation(c28333396.gthop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCondition(c28333396.gthcon2)
	e6:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e6)
end
function c28333396.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x283) and c:IsSummonLocation(LOCATION_EXTRA) and c:GetSequence()<5
end
function c28333396.indescon(e)
	return Duel.IsExistingMatchingCard(c28333396.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c28333396.rmlimit(e,c,tp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
function c28333396.defcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c28333396.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c28333396.rfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceup() and c:IsAbleToHand()
end
function c28333396.fthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c28333396.rfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,0,0)
end
function c28333396.fthop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectMatchingCard(tp,c28333396.rfilter,tp,LOCATION_MZONE,0,1,7,nil)
	if tg:GetCount()>0 then Duel.SendtoHand(tg,nil,REASON_EFFECT) end
end
function c28333396.cfilter(c,tp)
	return ((c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
	and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())) or (c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_MATERIAL))) and c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28333396.cfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
	and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()) and c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28333396.cfilter2(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_MATERIAL) and c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28333396.gthcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28333396.cfilter1,1,nil,tp)
end
function c28333396.gthcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28333396.cfilter2,1,nil,tp)
end
function c28333396.gthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c28333396.cfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,nil)
end
function c28333396.gthop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c28333396.cfilter,nil,tp)
	local mg=g:Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local og=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(og,nil,REASON_EFFECT)
	end
end

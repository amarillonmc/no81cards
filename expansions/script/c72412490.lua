--煌闪骑士团 贝鲁
function c72412490.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412490,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412490)
	e1:SetCondition(c72412490.spcon)
	e1:SetTarget(c72412490.sptg)
	e1:SetOperation(c72412490.spop)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c72412490.reptg)
	e2:SetValue(c72412490.repval)
	e2:SetOperation(c72412490.repop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72412490,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72412491)
	e3:SetCondition(c72412490.thcon)
	e3:SetTarget(c72412490.thtg)
	e3:SetOperation(c72412490.thop)
	c:RegisterEffect(e3)
end
function c72412490.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6727)
end
function c72412490.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72412490.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c72412490.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72412490.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c72412490.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6727) and c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c72412490.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c72412490.repfilter,1,e:GetHandler(),tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c72412490.repval(e,c)
	return c72412490.repfilter(c,e:GetHandlerPlayer())
end
function c72412490.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c72412490.thfilter(c,tp)
	return c:IsSetCard(0x6727) and c:IsType(TYPE_MONSTER) and not c:IsCode(72412490) and c:IsControler(tp)
end
function c72412490.defilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412490.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72412490.thfilter,1,nil,tp)
end
function c72412490.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c72412490.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c72412490.defilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72412490,0)) then
		local g=Duel.GetMatchingGroup(c72412490.defilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
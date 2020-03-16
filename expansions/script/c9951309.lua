--fate·伊莉雅
function c9951309.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9951309)
	e1:SetValue(c9951309.matval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951309,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99513090+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c9951309.thcon)
	e2:SetTarget(c9951309.thtg)
	e2:SetOperation(c9951309.thop)
	c:RegisterEffect(e2)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951309.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951309.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951309,0))
end
function c9951309.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xba5)
end
function c9951309.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(9951309)
end
function c9951309.matval(e,c,mg)
	return c:IsSetCard(0x103) and mg:IsExists(c9951309.mfilter,1,nil) and not mg:IsExists(c9951309.exmfilter,1,nil)
end
function c9951309.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0xba5) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c9951309.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9951309.cfilter,1,nil,tp)
end
function c9951309.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9951309.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end



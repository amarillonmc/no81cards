--什弥尼斯的神女 伊希丝
function c62501601.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501601,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c62501601.sumcon)
	e2:SetTarget(c62501601.sumtg)
	e2:SetOperation(c62501601.sumop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetOperation(c62501601.chainop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62501601,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501601)
	e4:SetTarget(c62501601.thtg)
	e4:SetOperation(c62501601.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end
c62501601.has_text_type=TYPE_SPIRIT
function c62501601.cfilter(c)
	return c:IsSetCard(0xea2) and c:IsFaceup()
end
function c62501601.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c62501601.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c62501601.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c62501601.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToChain() then return end
	Duel.Summon(tp,e:GetHandler(),true,nil)
end
function c62501601.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if (rc:IsRelateToEffect(re) and rc:IsPublic() and rc:IsSetCard(0xea2) and rc:IsControler(tp) or not rc:IsRelateToEffect(re) and rc:IsPreviousPosition(POS_FACEUP) and rc:IsPreviousSetCard(0xea2) and rc:IsPreviousControler(tp)) and re:GetActivateLocation()==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c62501601.chainlm)
	end
end
function c62501601.chainlm(e,rp,tp)
	return tp==rp
end
function c62501601.thfilter(c)
	return (c:IsSetCard(0xea2) or aux.IsTypeInText(c,TYPE_SPIRIT)) and c:IsAbleToHand()
end
function c62501601.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501601.thfilter,tp,LOCATION_DECK,0,1,nil,0) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62501601.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToChain() and aux.NecroValleyFilter()(c) and c:IsAbleToHand()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501601.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.SendtoHand(Group.FromCards(c,tc),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,Group.FromCards(c,tc))
end

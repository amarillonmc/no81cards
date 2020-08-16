--东风幼龙
function c871100001.initial_effect(c)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetTargetRange(POS_FACEUP_ATTACK,0)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c871100001.sprcon)
	c:RegisterEffect(e3)
   --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(871100001,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,81275020)
	e2:SetTarget(c871100001.thtg)
	e2:SetOperation(c871100001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c871100001.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c871100001.thfilter(c)
	return c:IsSetCard(0xfec1) and not c:IsCode(871100001) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c871100001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c871100001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c871100001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c871100001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

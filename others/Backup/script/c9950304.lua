--魔法少女☆伊莉雅
function c9950304.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,nil,2,2,c9950304.lcheck)
	c:EnableReviveLimit()
 --code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(9951285)
	c:RegisterEffect(e1)
--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950304,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,99503040)
	e3:SetTarget(c9950304.thtg)
	e3:SetOperation(c9950304.thop)
	c:RegisterEffect(e3)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950304,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9950304)
	e1:SetCondition(c9950304.spcon)
	c:RegisterEffect(e1)
   --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950304.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950304.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950304,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950304,1))
end
function c9950304.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xaba8)
end
function c9950304.thfilter(c,tp)
	return c:IsSetCard(0xaba8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9950304.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950304.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950304.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c9950304.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c9950304.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9950304.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaba8)
end
function c9950304.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950304.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
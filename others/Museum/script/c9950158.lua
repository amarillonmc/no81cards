--fate·茨木童子「Lancer」
function c9950158.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9950158+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c9950158.spcon)
	c:RegisterEffect(e1)
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950158,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c9950158.postg)
	e3:SetOperation(c9950158.posop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950158.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950158.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950158,0))
end
function c9950158.filter(c)
	return c:IsFaceup() and (c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0xba5)) and c:GetCode()~=9950158
end
function c9950158.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c9950158.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9950158.posfilter(c)
	return not c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition()
end
function c9950158.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9950158.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950158.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c9950158.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9950158.chlimit)
end
function c9950158.chlimit(e,ep,tp)
	return tp==ep
end
function c9950158.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950158,0))
end

--休比·多拉 日常
function c60000123.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60000123)
	e1:SetTarget(c60000123.tetg)
	e1:SetOperation(c60000123.teop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetCondition(c60000123.lvcon) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(4)
	c:RegisterEffect(e2)
end
function c60000123.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60000123.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.CreateToken(tp,60000125)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c60000123.ckfil(c)
	return not c:IsCode(60000123) and c:IsLevel(1) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c60000123.lvcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c60000123.ckfil,tp,LOCATION_MZONE,0,1,nil)
end










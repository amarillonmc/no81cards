--罗德岛·先锋干员-芬
function c79029151.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029151.spcon)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,79029151)
	e2:SetCondition(c79029151.damcon)
	e2:SetTarget(c79029151.damtg)
	e2:SetOperation(c79029151.damop)
	c:RegisterEffect(e2)	
end
function c79029151.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:GetCode()~=79029151
end
function c79029151.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c79029151.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c79029151.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) 
	and r==REASON_SYNCHRO 
end
function c79029151.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c79029151.damop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("大家跟着我！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029151,0))
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end




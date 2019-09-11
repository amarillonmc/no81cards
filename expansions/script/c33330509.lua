--末氏空骨的暗日
function c33330509.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--token!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330509,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33330509.con)
	e1:SetTarget(c33330509.tg)
	e1:SetOperation(c33330509.op)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTarget(c33330509.retg)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
end
function c33330509.confil(c,tp)
	return c:GetReasonPlayer()==tp and c:IsSetCard(0x5552)
end
function c33330509.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33330509.confil,1,nil,tp)
end
function c33330509.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33330500,0,0x4011,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33330509.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33330500,0,0x4011,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,33330500)
	local num=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(num*100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function c33330509.retg(e,c)
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK) and not c:IsSetCard(0x5552)
end
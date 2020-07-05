--罗德岛·先锋干员-桃金娘
function c79029140.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029140.spcon)
	c:RegisterEffect(e1)  
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c79029140.tg)
	e2:SetValue(c79029140.val)
	c:RegisterEffect(e2)
	--COUNTER
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c79029140.cttg)
	e4:SetOperation(c79029140.ctop)
	c:RegisterEffect(e4)
end
function c79029140.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:GetCode()~=79029140
end
function c79029140.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c79029140.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c79029140.val(e,c,Counter)  
	return e:GetHandler():GetCounter(0x1099)*100
end
function c79029140.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1099)
end
function c79029140.ctop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1099,x)
	end
end
function c79029140.tg(e,c)
	return c:IsSetCard(0xa903)
end










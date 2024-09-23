--异梦粉红小丑
if not c71400001 then dofile("expansions/script/c71400001.lua") end
function c71400039.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400039,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(yume.YumeCon)
	e1:SetCountLimit(1,71400039)
	e1:SetTarget(c71400039.tg1)
	e1:SetOperation(c71400039.op1)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c71400039.con2)
	e2:SetOperation(c71400039.op2)
	c:RegisterEffect(e2)
end
function c71400039.filter1(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsAbleToRemove()
end
function c71400039.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(c71400039.filter1,1,nil) end
	local g=eg:Filter(c71400039.filter1,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c71400039.filter1a(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c71400039.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=eg:Filter(c71400039.filter1a,nil,e,tp)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c71400039.con2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:GetBaseAttack()>2500 and rc:GetOriginalAttribute()==ATTRIBUTE_DARK and rc:IsSetCard(0x714)
end
function c71400039.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2a)
end
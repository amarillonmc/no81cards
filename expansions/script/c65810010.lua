--盛夏回忆·毒蚊
function c65810010.initial_effect(c)
	--手卡特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c65810010.condition1)
	c:RegisterEffect(e1)
	--墓地特招
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65810010+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c65810010.condition2)
	c:RegisterEffect(e2)
	--攻宣无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65810010.condition3)
	e3:SetCost(c65810010.cost3)
	e3:SetOperation(c65810010.activate3)
	c:RegisterEffect(e3)
end
function c65810010.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa31) and not c:IsCode(65810010) 
end
function c65810010.condition1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c65810010.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c65810010.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa31) and not c:IsCode(65810010) 
end
function c65810010.condition2(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65810010.filter2,tp,LOCATION_MZONE,0,1,nil)
end

function c65810010.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c65810010.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c65810010.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

--深海猎人·行动-顶级掠食者
function c79029086.initial_effect(c)
	c:EnableCounterPermit(0x191)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--COUNTER
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c79029086.rectg)
	e2:SetOperation(c79029086.recop)
	c:RegisterEffect(e2)
	--Win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c79029086.ctcost)
	e3:SetTarget(c79029086.cttg)
	e3:SetOperation(c79029086.ctop)
	c:RegisterEffect(e3)
end
function c79029086.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x191,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,tp,ev)
end
function c79029086.recop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x191,1)
end
function c79029086.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029086.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,nil,1,e:GetHandler(),79029085) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,nil,1,e:GetHandler(),79029010) and e:GetHandler():GetCounter(0x191)>=10 end
end
function c79029086.ctop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Win(tp,WIN_REASON_SPECTOR)
end 




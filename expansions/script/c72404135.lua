--大庭院的咒果 布雷登
function c72404135.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72404135,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c72404135.condition1)
	e1:SetOperation(c72404135.operation1)
	c:RegisterEffect(e1)
	--neg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72404135,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72404135)
	e2:SetCost(c72404135.cost2)
	e2:SetCondition(c72404135.condition2)
	e2:SetTarget(c72404135.target2)
	e2:SetOperation(c72404135.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72404135,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,72404136)
	e3:SetCondition(c72404135.condition3)
	e3:SetTarget(c72404135.target3)
	e3:SetOperation(c72404135.operation3)
	c:RegisterEffect(e3)
end

--e1
function c72404135.filter1(c,tp,rg)
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost()
end
function c72404135.condition1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72404135.filter1,tp,LOCATION_GRAVE,0,2,nil)
end
function c72404135.operation1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c72404135.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--e2
function c72404135.costfilter(c,e,tp)
	return c:IsSetCard (0x720) 
end
function c72404135.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c72404135.costfilter,1,e:GetHandler(),e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c72404135.costfilter,1,1,e:GetHandler(),e,tp)
	local rg=re:GetHandler() 
	if rg:IsLocation(LOCATION_GRAVE) then end
	Duel.SendtoGrave(g+rg,REASON_COST+REASON_RELEASE)
end

function c72404135.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) 
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c72404135.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c72404135.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--e3
function c72404135.confilter3(c,tp)
	return c:IsType(TYPE_MONSTER)  and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c72404135.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72404135.confilter3,1,e:GetHandler(),tp)
end
function c72404135.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c72404135.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

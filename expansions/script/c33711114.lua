--Lily White - Snow Falling Streets
local CTR_PETAL = 0x234
function c33711114.initial_effect(c)
	c:EnableCounterPermit(CTR_PETAL)
   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsType,TYPE_TOKEN),5,5,false)  
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)   
	--add counter
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33711114, 0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c33711114.cttg)
	e1:SetOperation(c33711114.ctop)
	c:RegisterEffect(e1)
--cannot be Destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
--SpecialSummon counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33711114, 1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c33711114.ctcost)
	e4:SetTarget(c33711114.target2)
	e4:SetOperation(c33711114.activate2)
	c:RegisterEffect(e4)
--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33711114, 2))
	e5:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c33711114.ctcost1)
	e5:SetTarget(c33711114.tg1)
	e5:SetOperation(c33711114.op1)
	c:RegisterEffect(e5)
end
function c33711114.cttg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 2, 0, CTR_PETAL)
end
function c33711114.ctop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(CTR_PETAL, 2)
	end
end
function c33711114.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,CTR_PETAL,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,CTR_PETAL,1,REASON_COST)
end
function c33711114.filter2(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c33711114.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33711114.filter2,1,nil,tp) end
	local g=eg:Filter(c33711114.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c33711114.filter3(c,e,tp)
	return c:IsFaceup() and c:GetAttack()>=1500 and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c33711114.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33711114.filter3,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c33711114.ctcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,CTR_PETAL,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,CTR_PETAL,4,REASON_COST)
end
function c33711114.tfilter1(c,e,tp)
	return c::IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(33711115)
end
function c33711114.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c33711114.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33711114.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c33711114.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c33711114.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
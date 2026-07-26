--化尘教长老-恒如真人
local s,id,o=GetID()
local CodeList=1202055	--四象天引录卡号
local CodeList2=1202035	--万尘化土卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList,CodeList2)
	c:EnableReviveLimit()
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetTarget(s.costtarget)
	e1:SetCost(s.costchk)
	e1:SetOperation(s.costop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(s.costtarget2)
	e2:SetCost(s.costchk2)
	e2:SetOperation(s.costop2)	
	c:RegisterEffect(e2)
	--cannot break
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(s.bop)
	c:RegisterEffect(e3)
	
end
function s.limfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9240)
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.limfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end

function s.costtarget(e,c)
	return s.con(e) and c:IsLevelAbove(5) and c:IsLevelBelow(6)
end
function s.costchk(e,c,tp)
	return Duel.CheckReleaseGroupEx(tp,nil,1,REASON_ACTION,false,nil)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,REASON_ACTION,false,nil)
	Duel.Release(g,REASON_COST)
end
function s.costtarget2(e,c)
	return s.con(e) and c:IsLevelAbove(7)
end
function s.costchk2(e,c,tp)
	return Duel.CheckReleaseGroupEx(tp,nil,2,REASON_ACTION,false,nil)
end
function s.costop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,nil,2,2,REASON_ACTION,false,nil)
	Duel.Release(g,REASON_COST)
end

function s.btg(e,c)
	return c:IsCode(CodeList)
end
function s.bop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>0 then return end
	--immue
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(s.btg)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
--金属化神明
local m=22348021
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348021,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c22348021.ttcon)
	e1:SetOperation(c22348021.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c22348021.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
--	local e4=Effect.CreateEffect(c)
--	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
--   e4:SetCode(EVENT_SUMMON_SUCCESS)
--	e4:SetOperation(c22348021.sumsuc)
--	c:RegisterEffect(e4)
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c22348021.splimit)
	c:RegisterEffect(e5)
	--immune
--	local e6=Effect.CreateEffect(c)
--	e6:SetType(EFFECT_TYPE_SINGLE)
--	e6:SetCode(EFFECT_IMMUNE_EFFECT)
--	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
--	e6:SetRange(LOCATION_MZONE)
--	e6:SetValue(c22348021.efilter)
--	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92385016,0))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c22348021.ngcost)
	e7:SetCondition(c22348021.ngcondition)
	e7:SetTarget(c22348021.ngtarget)
	e7:SetOperation(c22348021.ngactivate)
	c:RegisterEffect(e7)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92385016,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c22348021.retg)
	e3:SetOperation(c22348021.reop)
	c:RegisterEffect(e3)
	
end
function c22348021.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c22348021.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c22348021.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c22348021.splimit(e,se,sp,st)
	return st&SUMMON_VALUE_MONSTER_REBORN>0
		and e:GetHandler():IsControler(sp) and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c22348021.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler()==c
			end
end
function c22348021.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c22348021.genchainlm(e:GetHandler()))
end
function c22348021.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22348021.cfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c22348021.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348021.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348021.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c22348021.ngcondition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetOwner()~=e:GetOwner()
end
function c22348021.ngtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local rg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsAbleToRemove() then
				rg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(rg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
end
function c22348021.ngactivate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsAbleToRemove() then
				tc:CancelToGrave()
				rg:AddCard(tc)
			end
		end
	end
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
function c22348021.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c22348021.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
end


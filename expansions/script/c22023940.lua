--人类恶·秩宙 太空艾蕾什基伽尔
function c22023940.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,22023920,22023930,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22023940.effcon)
	e2:SetValue(c22023940.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22023940.effcon)
	e3:SetValue(c22023940.effectfilter)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_ONFIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(c22023940.distarget)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCondition(c22023940.gudacon)
	e5:SetTarget(c22023940.distarget)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22023940,0))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(c22023940.recon)
	e6:SetTarget(c22023940.retg)
	e6:SetOperation(c22023940.reop)
	c:RegisterEffect(e6)
	--remove ere
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22023940,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCondition(c22023940.recon1)
	e7:SetCost(c22023940.erecost)
	e7:SetTarget(c22023940.retg)
	e7:SetOperation(c22023940.reop)
	c:RegisterEffect(e7)
	if not c22023940.global_flag then
		c22023940.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22023940.regop0)
		Duel.RegisterEffect(ge1,0)
		c22023940.global_flag=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(c22023940.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c22023940.regop0(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22020000) then
			Duel.RegisterFlagEffect(tp,22020000,0,0,0)
		elseif tc:IsCode(22023950) then
			Duel.RegisterFlagEffect(tp,22023950,0,0,0)
		end
	end
end
function c22023940.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22023950) then
			Duel.RegisterFlagEffect(tp,22023950,0,0,0)
		end
	end
end
function c22023940.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023950)>0
end
function c22023940.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function c22023940.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function c22023940.distarget(e,c)
	return c~=e:GetHandler()
end
function c22023940.spfilter(c)
	return c:IsCode(22020000) and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c22023940.gudacon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22023940.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) 
end
function c22023940.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22020000)>0
end
function c22023940.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22023940,2))
	Duel.SelectOption(tp,aux.Stringid(22023940,3))
end
function c22023940.reop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.SelectOption(tp,aux.Stringid(22023940,4))
end
function c22023940.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023940.recon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22020000)>0 and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
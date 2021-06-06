--MONO Poro
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(9310021,"PORO")
function c9310021.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c9310021.ffilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9310021)
	e1:SetTarget(c9310021.cttg)
	e1:SetOperation(c9310021.ctop)
	c:RegisterEffect(e1)
	--no xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9310021.indcon)
	e2:SetValue(c9310021.efilter)
	c:RegisterEffect(e2)
	--nontuner
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9311021)
	e4:SetCost(c9310021.spcost)
	e4:SetTarget(c9310021.sptg)
	e4:SetOperation(c9310021.spop)
	c:RegisterEffect(e4)
end
function c9310021.ffilter(c)
	return rk.check(c,"PORO") or c:IsFusionSetCard(0x3f91)
end
function c9310021.ctfilter1(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c9310021.ctfilter2(c)
	local tp=c:GetControler()
	return c:IsFaceup() and aux.AtkEqualsDef(c) and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c9310021.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9310021.ctfilter1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c9310021.ctfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c9310021.ctfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c9310021.ctfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c9310021.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
		Duel.SwapControl(a,b)
	end
end
function c9310021.indcon(e)
	return e:GetHandler():IsDefensePos()
end
function c9310021.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c9310021.cfilter(c,tp)
	return aux.AtkEqualsDef(c) and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.GetMZoneCount(tp,c)>0
end
function c9310021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9310021.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c9310021.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9310021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9310021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
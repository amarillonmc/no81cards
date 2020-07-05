--维多利亚·术士干员-夜烟
function c79029139.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,
	0xa905),aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),true)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029139.lzcon)
	e1:SetOperation(c79029139.lzop)
	c:RegisterEffect(e1)  
	--funsion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7241272,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029139+EFFECT_COUNT_CODE_DUEL)
	e2:SetLabel(0)
	e2:SetCost(c79029139.cost)
	e2:SetTarget(c79029139.sptg)
	e2:SetOperation(c79029139.spop)
	c:RegisterEffect(e2)	   
end
function c79029139.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=0
end
function c79029139.lzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.SpecialSummon(a,0,tp,tp,true,true,POS_FACEUP)~0 then 
	tc=a:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=a:GetNext()
end
end
end
function c79029139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029139.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c79029139.filter2,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c79029139.filter2(c,lv,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79029139.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c79029139.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c79029139.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029139.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029139.filter2,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
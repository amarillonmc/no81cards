--堕魔剂
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:GetHandler():IsSetCard(0x3fd5) and re:IsActiveType(TYPE_TRAP) and loc==LOCATION_HAND 
end
function cm.tgf1(c,e,tp)
	return c:IsSetCard(0xfd6) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.tgff1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and c:IsReleasable()
end
function cm.tgff1(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(10) and c:IsSetCard(0x3fd6) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) and Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.cop1)
end
function cm.cop1(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if Duel.Release(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,cm.tgff1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if not sc then return end
	sc:SetMaterial(nil)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		sc:CompleteProcedure()
	end
end
--光壳流溢的虚树
abi=abi or {}
abi.loaded_metatable_list={}

abi.code=0

local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(9) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsRace(RACE_FAIRY)
end
function cm.tdfil(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local code=tc:GetCode()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local tdg=Duel.GetMatchingGroup(cm.tdfil,tp,LOCATION_MZONE,0,nil,code)
		if tdg then Duel.SendtoDeck(tdg,nil,0,REASON_RULE) end
		local fg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x1ff,0,nil,24094653)
		for tc in aux.Next(fg) do
			tc:ReplaceEffect(60001291,nil)
		end
		abi.code=code
	end
end
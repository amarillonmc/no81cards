local m=15000114
local cm=_G["c"..m]
cm.name="超越时间之影"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000113)
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsCanRemoveCounter(tp,1,1,0x1f30,9,REASON_COST) or e:GetHandler():GetFlagEffect(15000113)~=0) end
	if e:GetHandler():GetFlagEffect(15000113)~=0 and Duel.IsCanRemoveCounter(tp,1,1,0x1f30,9,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return true end
	if e:GetHandler():GetFlagEffect(15000113)~=0 and not Duel.IsCanRemoveCounter(tp,1,1,0x1f30,9,REASON_COST) then return true end
	Duel.RemoveCounter(tp,1,1,0x1f30,9,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return (c:IsType(TYPE_RITUAL) or (c:IsLocation(LOCATION_PZONE) and bit.band(c:GetOriginalType(),TYPE_RITUAL)==TYPE_RITUAL)) and c:IsCode(15000113) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_PZONE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP) then
--Debug.Message("红啊！聆听神的鸣叫，窃取神的名字，将他们拖入")
--Debug.Message("你曾挣扎的深渊！")
--Debug.Message("红！！！！")
		tc:CompleteProcedure()
	end
end
--焰之巫女 扎拉
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009770)
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1,99)   

   --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)


	local e4 = rsef.FTF(c,EVENT_PHASE+PHASE_END,"tf",nil,"tg",nil,
		LOCATION_MZONE,cm.tgcon,nil,
		rsop.target({Card.IsAbleToGrave,"tg"},
		{cm.tffilter,"tf",LOCATION_GRAVE }),cm.tgop)
end

function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsLevel(3) and c:IsSetCard(0x6f1b))
end
function cm.costfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsDiscardable()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return ((c:IsSetCard(0xcf1b) and c:IsType(TYPE_RITUAL)) or c:IsCode(40009579)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
	tc:CompleteProcedure()
end





function cm.tgcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.tgop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or Duel.SendtoGrave(c,REASON_EFFECT) <= 0 or not c:IsLocation(LOCATION_GRAVE) then return end
	rsop.SelectOperate("tf",tp,aux.NecroValleyFilter(cm.tffilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.tffilter(c,e,tp)
	return c:IsSetCard(0xaf1b) and c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
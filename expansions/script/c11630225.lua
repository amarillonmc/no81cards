--仪式解除
local this,id,ofs=GetID()
function this.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(this.tg)
	e1:SetOperation(this.op)
	c:RegisterEffect(e1)
end
function this.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsAbleToDeck()
end
function this.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and this.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function this.mgfilter(c,e,tp,ritc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&(REASON_RITUAL+REASON_MATERIAL)==(REASON_RITUAL+REASON_MATERIAL) and c:GetReasonCard()==ritc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
    local b1=tc:IsSummonType(SUMMON_TYPE_RITUAL)
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK)
		and b1
		and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct==1)
		and mg:FilterCount(aux.NecroValleyFilter(this.mgfilter),nil,e,tp,tc)==ct
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end

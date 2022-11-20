--置换连接
function c10173099.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10173099+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10173099.cost)
	e1:SetTarget(c10173099.target)
	e1:SetOperation(c10173099.activate)
	c:RegisterEffect(e1)
end
function c10173099.cost(e,tp)
	e:SetLabel(100)
	return true
end
function c10173099.tdfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToExtra() and c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c10173099.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c) 
end
function c10173099.spfilter(c,e,tp,rc,rc2)
	if c:GetLink()~=rc:GetLink() or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCountFromEx(tp,tp,rc2,c)<=0 then return false end
	local tbl={0x001,0x002,0x004,0x008,0x020,0x040,0x080,0x100}
	for k,v in ipairs(tbl) do
		if c:IsLinkMarker(v) and not rc:IsLinkMarker(v) then 
		return true
		end
	end
	return false
end
function c10173099.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10173099.tdfilter(chkc,e,tp) end
	if chk==0 then 
		if e:GetLabel()~=100 then
			e:SetLabel(0)
			return false
		end
		return Duel.IsExistingTarget(c10173099.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10173099.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10173099.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c10173099.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	   local sg=Duel.SelectMatchingCard(tp,c10173099.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	   if sg:GetCount()>0 then
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end 
	end
end
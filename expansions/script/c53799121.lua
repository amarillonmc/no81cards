local m=53799121
local cm=_G["c"..m]
cm.name="炎鸟化"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c,e,tp)
	return c:IsSetCard(0x9f38) and c:IsType(TYPE_XYZ) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetRank())
end
function cm.spfilter(c,e,tp,rk)
	return c:IsLevel(rk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetRank())
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsCanOverlay()
		and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,c,e,tp,c,c:GetLevel())
end
function cm.filter2(c,e,tp,mtc,lv)
	return c:IsLevel(lv) and c:IsFaceup() and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,mtc,c,c:GetLevel(),Group.FromCards(c,mtc))
end
function cm.filter3(c,e,tp,mc1,mc2,lv,mg)
	return c:IsRank(lv) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x9f38) and mc1:IsCanBeXyzMaterial(c) and mc2:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsAbleToExtra()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetHandler():IsCanOverlay() and Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,tc1,e,tp,tc1,tc1:GetLevel())
	local tc2=g2:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,cm.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc1,tc2,tc2:GetLevel(),Group.FromCards(tc1,tc2))
	e:SetLabelObject(g3:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g3,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g3,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if tc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and #tg==2 and tg:GetFirst():IsRelateToEffect(e) and tg:GetNext():IsRelateToEffect(e) then
		local dg=Group.CreateGroup()
		for mtc in aux.Next(tg) do
			local mg=mtc:GetOverlayGroup()
			if mg:GetCount()~=0 then dg:Merge(mg) end
		end
		if c:IsRelateToEffect(e) and c:IsCanOverlay() then
			c:CancelToGrave()
			dg:AddCard(c)
		end
		if dg:GetCount()~=0 then Duel.Overlay(tc,dg) end
		tc:SetMaterial(tg)
		Duel.Overlay(tc,tg)
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end

local m=82224075
local cm=_G["c"..m]
cm.name="升阶魔法-辉耀之力"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end
function cm.filter1(c,e,tp)  
	local rk=c:GetRank()  
	return rk>0 and c:IsFaceup() and c:GetBaseAttack()<=1000 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)  
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)  
end  
function cm.filter2(c,e,tp,mc,rk)  
	return c:IsRank(rk) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x48) and mc:IsCanBeXyzMaterial(c)  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)  
		and e:GetHandler():IsCanOverlay() end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end  
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)  
	local sc=g:GetFirst()  
	if sc then  
		local mg=tc:GetOverlayGroup()  
		if mg:GetCount()~=0 then  
			Duel.Overlay(sc,mg)  
		end  
		sc:SetMaterial(Group.FromCards(tc))  
		Duel.Overlay(sc,Group.FromCards(tc))  
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
		sc:CompleteProcedure()  
		if c:IsRelateToEffect(e) then  
			c:CancelToGrave()  
			Duel.Overlay(sc,Group.FromCards(c))  
		end  
	end  
end  
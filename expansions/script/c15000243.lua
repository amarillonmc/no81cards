local m=15000243
local cm=_G["c"..m]
cm.name="茶会：永寂之国"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
end
function cm.tgfilter1(c)  
	return c:IsFaceup() and (c:IsType(TYPE_LINK) or c:IsType(TYPE_XYZ))
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0xf37) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end 
function cm.sp2filter(c)  
	return c:IsType(TYPE_LINK) and c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter1(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter1,tp,LOCATION_MZONE,0,1,nil) and ((Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_GRAVE,0,1,nil)) or (Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp))) end   
	local g=Group.CreateGroup() 
	if (Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_GRAVE,0,1,nil)) then
		local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ)
		Group.Merge(g,g1)
	end
	if (Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)) then
		local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_LINK)
		Group.Merge(g,g2)
	end
	local g3=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	Group.Sub(g3,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter1,tp,LOCATION_MZONE,0,1,1,g3)  
	if g:GetFirst():IsType(TYPE_LINK) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFirstTarget()
	if tc:IsType(TYPE_LINK) and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() then
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=g:GetFirst()  
		if sc then   
			local mg=tc:GetOverlayGroup()  
			if mg:GetCount()>0 then  
				Duel.Overlay(sc,mg)  
			end
			sc:SetMaterial(Group.FromCards(tc))  
			Duel.Overlay(sc,Group.FromCards(tc))  
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
			sc:CompleteProcedure()  
		end
	else
		if tc:IsType(TYPE_XYZ) and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() then
			local g=Duel.SelectMatchingCard(tp,cm.sp2filter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.Overlay(tc,g)
		end
	end
end
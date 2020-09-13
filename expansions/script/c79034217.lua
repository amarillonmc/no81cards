local m=79034217
local cm=_G["c"..m]
cm.name="小红花"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_MOVE)
	e3:SetCountLimit(1,79034217)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.ctcon1)
	e3:SetTarget(cm.cttg1)
	e3:SetOperation(cm.ctop1)
	c:RegisterEffect(e3)
end
function cm.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xca12) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.ovfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xca12) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and c:IsCanBeEffectTarget(e)
end
function cm.xyzfilter(c,e,tp,lv,mc)
	return c:IsType(TYPE_XYZ) and c:IsRank(lv) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ovfilter,tp,LOCATION_MZONE,0,nil,e)
	if g:GetCount()==0 then return false end
	local ag=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel(),tc) then
			ag:AddCard(tc)
		end
		tc=g:GetNext()
	end
	return ag:GetCount()~=0 and eg:IsExists(cm.cfilter,1,e:GetHandler(),tp)
end
function cm.cttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.ovfilter,tp,LOCATION_MZONE,0,nil,e)
	if g:GetCount()==0 then return false end
	local ag=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel(),tc) then
			ag:AddCard(tc)
		end
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ac=ag:Select(tp,1,1,nil)
	Duel.SetTargetCard(ac)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ac=ag:GetFirst()
	if ac:IsFaceup() and ac:IsRelateToEffect(e) and ac:IsControler(tp) and not ac:IsImmuneToEffect(e) and aux.MustMaterialCheck(ac,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ac:GetLevel(),ac)
		local tc=g:GetFirst()
		if tc then
			local mg=ac:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(ac))
			Duel.Overlay(tc,Group.FromCards(ac))
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
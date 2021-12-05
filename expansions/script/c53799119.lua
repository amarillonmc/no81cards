local m=53799119
local cm=_G["c"..m]
cm.name="奏者化"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.xyzfilter(c)
	return c:IsSetCard(0x9f38) and c:IsXyzSummonable(nil)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
function cm.filter1(c,e,tp)
	local code=c:GetOriginalCode()
	local class=_G["c"..code]
	if class==nil or class.rkup==nil then return false end
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x9f38)
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,class,e,tp,c,c:GetRank()+3)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.filter2(c,class,e,tp,mc,rk)
	return c:IsRankBelow(rk) and c:IsCode(table.unpack(class.rkup)) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x9f38) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.matfilter(c)
	return c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsCanOverlay() and Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=tc:GetOriginalCode()
	local class=_G["c"..code]
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_HAND,0,1,1,nil)
		g:AddCard(c)
		if c:IsCanOverlay() then c:CancelToGrave() end
		if g:GetCount()>0 and Duel.Overlay(tc,g)~=0 then
			if tc:IsFacedown() or tc:IsControler(1-tp) or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) or class==nil or class.rkup==nil then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,class,e,tp,tc,tc:GetRank()+3)
			local sc=sg:GetFirst()
			if sc then
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
			end
		end
	end
end

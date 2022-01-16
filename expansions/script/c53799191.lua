local m=53799191
local cm=_G["c"..m]
cm.name="魂之升格"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	local class=_G["c"..c:GetOriginalCode()]
	if class==nil or class.rkup==nil then return false end
	return c:IsFaceup() and c:IsSetCard(0x9f38)
end
function cm.spfilter(c,class,e,tp,mc)
	if class==nil or class.rkup==nil then return false end
	return c:IsCode(table.unpack(class.rkup)) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local class=_G["c"..tc:GetOriginalCode()]
	local opt=1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,class,e,tp,tc) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else e:SetCategory(0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or (opt==0 and (tc:IsImmuneToEffect(e) or tc:IsFacedown())) then return end
	local class=_G["c"..tc:GetOriginalCode()]
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,class,e,tp,tc):GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then Duel.Overlay(sc,mg) end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
		end
	else
		local g=Group.CreateGroup()
		while class.rkup~=nil do
			local rk=table.unpack(class.rkup)
			local cre=Duel.CreateToken(tp,rk)
			Duel.SendtoHand(cre,nil,REASON_EFFECT)
			g:AddCard(cre)
			class=_G["c"..rk]
		end
		Duel.ConfirmCards(1-tp,g)
	end
end

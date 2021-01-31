local m=15000097
local cm=_G["c"..m]
cm.name="升阶魔法-蝶舞死生"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:GetOverlayCount()==0
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,c:GetAttribute(),c:GetRace())
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.filter2(c,e,tp,mc,rk,att,rac)
	if c:GetOriginalCode()==6165656 and mc:GetCode()~=48995978 then return false end
	return c:IsRank(rk) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:GetAttribute()~=att and c:GetRace()==rac and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.filter3(c)
	return c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if Duel.IsExistingTarget(cm.filter3,tp,LOCATION_ONFIELD,0,1,Group.FromCards(tc,e:GetHandler())) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local ac=Duel.SelectTarget(tp,cm.filter3,tp,LOCATION_ONFIELD,0,1,1,Group.FromCards(tc,e:GetHandler())):GetFirst()
		e:SetLabelObject(ac)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=bg:GetFirst()
	if bg:GetCount()==1 then tc=bg:GetFirst() end
	if bg:GetCount()==2 then 
		if tc==e:GetLabelObject() then tc=bg:GetNext() end
	end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetAttribute(),tc:GetRace())
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
		if bg:GetCount()==2 then
			local ac=e:GetLabelObject()
			if ac:IsRelateToEffect(e) and ac:IsFaceup() and ac:IsControler(tp) and not ac:IsImmuneToEffect(e) then
				ac:CancelToGrave()
				local ovg=ac:GetOverlayGroup()
				if ovg:GetCount()~=0 then
				   Duel.Overlay(sc,ovg)
				end
				Duel.Overlay(sc,ac)
			end
		end
	end
end
local m=15000484
local cm=_G["c"..m]
cm.name="超维的星拟龙"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000495)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.rcon)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsFaceup() and ((c:IsSetCard(0xf34) and not c:IsType(TYPE_XYZ)) or (c:IsType(TYPE_LINK) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK))) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cm.spfilter(c,e,tp,mc)
	return c:IsCode(15000495)
		and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=Duel.GetFirstTarget()
	if mc:IsFaceup() and mc:IsRelateToEffect(e) and mc:IsControler(tp) and not mc:IsImmuneToEffect(e)
		and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc)
		local tc=g:GetFirst()
		if tc then
			local mg=mc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(mc))
			Duel.Overlay(tc,Group.FromCards(mc))
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x3f34)
		and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToRemoveAsCost() and ep==e:GetOwnerPlayer()
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
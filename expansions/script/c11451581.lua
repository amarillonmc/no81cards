--樱绽樱飞樱之町
--21.06.23
local m=11451581
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect1 gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--effect2 gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(cm.xmtg)
	e4:SetOperation(cm.xmop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0xff,0xff)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--become effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ADD_TYPE)
	e6:SetValue(TYPE_EFFECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(cm.betg)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
	end
end
function cm.eftg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x97f)
end
function cm.betg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x97f) and not c:IsType(TYPE_EFFECT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,3,REASON_COST) and c:GetFlagEffect(m)==0 end
	c:RemoveOverlayCard(tp,3,3,REASON_COST)
end
function cm.filter(c,e,tp,rk,mc)
	return c:IsRankBelow(rk) and c:IsSetCard(0x9f38) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and mc:IsCanBeXyzMaterial(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank()+3,c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank()+3,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function cm.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (cm[tp]==0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0) or (cm[tp]==1 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)) or (cm[tp]==2 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)) end
end
function cm.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function cm.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if cm[tp]==0 then
		local g=Duel.GetDecktopGroup(1-tp,1)
		if c:IsRelateToEffect(e) and #g==1 then
			Duel.DisableShuffleCheck()
			Duel.Overlay(c,g)
			cm[tp]=1
		end
	elseif cm[tp]==1 then
		if c:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsCanOverlay),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
			if #g==0 then return end
			Duel.Overlay(c,g)
			cm[tp]=2
		end
	elseif cm[tp]==2 then
		if c:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,e)
			if #g==0 then return end
			local rc=g:GetFirst()
			rc:CancelToGrave()
			local og=rc:GetOverlayGroup()
			if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
			Duel.Overlay(c,g)
			cm[tp]=0
		end
	end
end
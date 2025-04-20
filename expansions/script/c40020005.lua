--朱斯贝克·天坠黎骑·再锻
local m=40020005
local cm=_G["c"..m]
cm.named_with_Youthberk=1
function cm.Rebellionform(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Rebellionform
end
function cm.Skyform(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Skyform
end
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	--code
	aux.EnableChangeCode(c,40010501,LOCATION_MZONE+LOCATION_GRAVE)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)

end
function cm.mfilter(c,xyzc)
	return c:IsLevelAbove(2) and not c:IsLevel(1,3,5,7,9,11)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==1-tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function cm.spfilter(c,e,tp,mc)
	return (cm.Rebellionform(c) or cm.Skyform(c)) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
			if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetCountLimit(1)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCondition(cm.op1con)
				e1:SetOperation(cm.op1op)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
				e1:SetLabelObject(c)
				sc:RegisterEffect(e1)
			end
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.op1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(m)>0
end
function cm.op1op(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local c=e:GetHandler()
	if not c:GetOverlayGroup():IsContains(sc) then return end
	if Duel.SendtoDeck(sc,tp,0,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_EXTRA) then
		if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		if not (c:IsFaceup() and not c:IsImmuneToEffect(e)) then return end
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(sc,mg) end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

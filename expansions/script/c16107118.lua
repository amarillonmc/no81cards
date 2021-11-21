--G－神智主机　迪萨贝尔
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16107118,"GODONOVALORD")
local nova=0x1cc ----nova counter
function cm.initial_effect(c)
	--xyz summon
	c:EnableCounterPermit(nova)
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,1,1)
	c:EnableReviveLimit()
	--XYZ SUM
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1) 
	--RANK CHANGE
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ANNOUNCE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.crcon1)
	e2:SetTarget(cm.crtg)
	e2:SetOperation(cm.crop)
	c:RegisterEffect(e2) 
	--XYZ RE
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(cm.xyzcost)
	e3:SetCondition(cm.xyzcon1)
	e3:SetTarget(cm.xyztg)
	e3:SetOperation(cm.xyzop)
	c:RegisterEffect(e3)

	--RANK CHANGE QuickBuff
	local e2_1=e2:Clone()
	e2_1:SetType(EFFECT_TYPE_QUICK_O)
	e2_1:SetCode(EVENT_FREE_CHAIN)
	e2_1:SetHintTiming(0,TIMING_END_PHASE)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCondition(cm.crcon2)
	c:RegisterEffect(e2_1)
	--XYZ RE QuickBuff
	local e3_1=e3:Clone()
	e3_1:SetType(EFFECT_TYPE_QUICK_O)
	e3_1:SetHintTiming(0,TIMING_END_PHASE)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetCondition(cm.xyzcon2)
	e3_1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3_1)
end
function cm.mfilter(c,xyzc)
	return c:IsCode(16107117)
end
function cm.splimit(e,se,sp,st)
	if st&SUMMON_TYPE_XYZ ~=0 then
		return not se or not se:IsHasType(EFFECT_TYPE_ACTIONS)
	else
		return true
	end
end
function cm.crcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)==0
end
function cm.crcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)~=0 and e:GetHandler():IsOriginalSetCard(0xccc)
end
function cm.crtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_NUMBER)
	local lv=Duel.AnnounceLevel(tp)
	e:SetLabel(lv)
end
function cm.filter(c,lv)
	return rk.check(c,"GODONOVAARMS") and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_XYZ)
end
function cm.crop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rank=e:GetLabel()
	if not (rank>0) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e:GetLabel())
	if g:GetCount()~=0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetValue(rank)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.xyzcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)==0
end
function cm.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)~=0 and e:GetHandler():IsOriginalSetCard(0xccc)
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:IsSetCard(0x5ccc) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.filter2(c,e,tp,mc)
	local rk=0
	if mc:IsType(TYPE_XYZ) then
		rk=mc:GetRank()
	elseif mc:IsType(TYPE_LINK) then
		rk=mc:GetLink()*2
	else
		rk=mc:GetLevel()
	end
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:GetRank()==rk and c:IsSetCard(0x5ccc)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
	sc:CompleteProcedure()
end
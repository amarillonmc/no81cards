--朱斯贝克·天坠黎骑
local m=40010501
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
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.xyzlv)
	c:RegisterEffect(e1) 
 
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,m)
	--e2:SetCondition(cm.xyzcon1)
	e2:SetCost(cm.xyzcost)
	e2:SetTarget(cm.xyztg)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)

end

function cm.xyzlv(e,c,rc)
	return c:GetRank()
end

function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,40010906) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.xyzfilter1(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and (cm.Rebellionform(c) or (cm.Skyform(c) and mc:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40010906))) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.xyzfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and (cm.Skyform(c) or (cm.Rebellionform(c) and mc:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40010906))) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()


	if Duel.GetTurnPlayer()==tp then
		if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(cm.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(cm.xyzfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if Duel.GetTurnPlayer()==tp then
			local g=Duel.SelectMatchingCard(tp,cm.xyzfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			local tc=g:GetFirst()
			if tc then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()>0 then
					Duel.Overlay(tc,mg)
				end
				tc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(tc,Group.FromCards(c))
				if Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
					tc:CompleteProcedure()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e1:SetCountLimit(1)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCondition(cm.op1con)
					e1:SetOperation(cm.op1op)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
					e1:SetLabelObject(c)
					tc:RegisterEffect(e1)
				end
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				Duel.SpecialSummonComplete()
			end
		else
			local g=Duel.SelectMatchingCard(tp,cm.xyzfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			local tc=g:GetFirst()
			if tc then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()>0 then
					Duel.Overlay(tc,mg)
				end
				tc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(tc,Group.FromCards(c))
				if Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
					tc:CompleteProcedure()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e1:SetCountLimit(1)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCondition(cm.op1con)
					e1:SetOperation(cm.op1op)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
					e1:SetLabelObject(c)
					tc:RegisterEffect(e1)
				end
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				Duel.SpecialSummonComplete()
			end
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

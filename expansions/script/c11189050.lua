--湮潮使·羽
local s,id,o=GetID()
function s.initial_effect(c)
	--
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	--
	aux.EnablePendulumAttribute(c)
	--
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ptg1)
	e1:SetOperation(s.pop1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,id+3)
	e2:SetCost(s.mtcost1)
	e2:SetTarget(s.mtg1)
	e2:SetOperation(s.mop1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.mcost2)
	e3:SetTarget(s.mtg2)
	e3:SetOperation(s.mop2)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+2)
	e4:SetCondition(s.mcon3)
	e4:SetTarget(s.mtg3)
	e4:SetOperation(s.mop3)
	c:RegisterEffect(e4)
end
function s.mfilter(c)
	return aux.IsCodeListed(c,0x452)
end
function s.pfilter(c,e,tp)
	return c:IsSetCard(0x5454) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSummonable(true,nil))
end
function s.ptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
end
function s.pop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=tc:IsSummonable(true,nil)
	local op=aux.SelectFromOptions(tp,{b1,1152},{b2,aux.Stringid(id,4)})
	if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.mthfilter(c)
	return c:IsSetCard(0x5454) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.msumfilter(c)
	return c:IsSetCard(0x5454) and c:IsSummonable(true,nil)
end
function s.mtcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST)
end
function s.mtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.mthfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.mop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.mthfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g)
	if Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		if Duel.RemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(s.msumfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.msumfilter,tp,LOCATION_HAND,0,1,1,nil)
			if #sg>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function s.xyzfilter1(c,e,tp,mc,ct)
	return aux.IsCodeListed(c,0x452) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRankBelow(ct)
end
function s.xyzfilter2(c,e,tp,mc,ct)
	return aux.IsCodeListed(c,0x452) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRank(ct)
end
function s.mcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,1,0,0x452)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,ct)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) end
	local rktable={}
	local g=Duel.GetMatchingGroup(s.xyzfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,c,ct)
	for i=1,ct do
		if g:IsExists(Card.IsRank,1,nil,i) then
			table.insert(rktable,i)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,6))
	local ac=Duel.AnnounceNumber(tp,table.unpack(rktable))
	Duel.RemoveCounter(tp,1,0,0x452,ac,REASON_COST)
	e:SetLabel(ac)
end
function s.mtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and e:IsCostChecked() end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.mop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel(ac)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local mg=Group.FromCards(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.xyzfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,ct)
	local tc=g:GetFirst()
	if tc then
		Duel.BreakEffect()
		tc:SetMaterial(mg)
		Duel.Overlay(tc,mg)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end
function s.mcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.mtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.mop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
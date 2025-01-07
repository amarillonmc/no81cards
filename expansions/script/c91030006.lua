--まどろみの神碑
local m=91030006
local cm=c91030006
function c91030006.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE+TIMING_DRAW_PHASE,TIMING_END_PHASE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	 return (Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2) or Duel.GetTurnPlayer()~=tp
end
function cm.filter(c,e,tp,spchk)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToRemove() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) or  Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,spchk) end
	local b1=Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,spchk)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
	 local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0)},
			{b2,aux.Stringid(m,1)},
			{b3,aux.Stringid(m,2)})
	if op==1 then
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,spchk)
	Duel.HintSelection(g)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e:GetHandler():RegisterFlagEffect(1,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:GetHandler():RegisterFlagEffect(2,RESET_PHASE+PHASE_END,0,1)
	elseif op==3 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:GetHandler():RegisterFlagEffect(3,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:GetFlagEffect(1)>0  then
	if tc and tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_QUICKPLAY)>=3
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)		
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
	c:ResetFlagEffect(1)
	elseif c:GetFlagEffect(2)>0  then
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.tgcon)
		e1:SetOperation(cm.tgop)
		Duel.RegisterEffect(e1,tp)
	c:ResetFlagEffect(2)
	elseif c:GetFlagEffect(3)>0  then
	local g=Duel.SelectMatchingCard(tp,cm.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	   if #g>0 then Duel.LinkSummon(tp,g:GetFirst(),nil) end
	c:ResetFlagEffect(3)
	end
end
function cm.lfilter(c)
	return c:IsLinkSummonable(nil)
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end

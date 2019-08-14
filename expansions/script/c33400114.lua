--遥不可及的幸福
function c33400114.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c33400114.target)
	e1:SetOperation(c33400114.activate)
	c:RegisterEffect(e1)
end
function c33400114.tfilter(c,e,tp)
	return c:IsCode(33400011) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33400114.filter(c,e,tp)
	return  c:IsSetCard(0x3341)
		and Duel.IsExistingMatchingCard(c33400114.tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c33400114.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3341) 
end
function c33400114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c33400114.chkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400114.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c33400114.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33400114.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33400114.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		local tc=sg:GetFirst()
		tc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		 tc:RegisterFlagEffect(33400114,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		 local e3=Effect.CreateEffect(e:GetHandler())
		  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e3:SetCode(EVENT_PHASE+PHASE_END)
		  e3:SetCountLimit(1)
		  e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e3:SetLabel(fid)
		  e3:SetLabelObject(tc)
		  e3:SetCondition(c33400114.tgcon)
		  e3:SetOperation(c33400114.tgop)
		  Duel.RegisterEffect(e3,tp)
	end
end
function c33400114.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33400114)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c33400114.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(c33400114.ss,tp,LOCATION_GRAVE,0,nil,e,tp)
		if dg:GetCount()>0  and Duel.SelectYesNo(tp,aux.Stringid(33400114,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)		   
			local g=Duel.SelectMatchingCard(tp,c33400114.ss,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)		  
			local  tc=g:GetFirst()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c33400114.ss(c,e,tp)
	return c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


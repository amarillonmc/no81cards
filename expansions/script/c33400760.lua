--七罪 幻化魔法
local m=33400760
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.tfilter(c,code,e,tp,tc)
	return c:IsSetCard(0x3342) and c:IsType(TYPE_FUSION) and c:IsLevelBelow(8) and c:GetCode()~=code
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and ((c:IsSetCard(0x341) and c:IsLevel(8)) or c:GetCode()~=c:GetOriginalCode()) 
		and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode(),e,tp,c)
end
function cm.chkfilter(c)
	return c:IsFaceup() and ((c:IsSetCard(0x341) and c:IsLevel(8)) or c:GetCode()~=c:GetOriginalCode()) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.chkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,code,e,tp,nil)
	if sg:GetCount()>0 then
	local tc1=sg:GetFirst()
		Duel.BreakEffect()
		Duel.SpecialSummon(tc1,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)		  
		 if  Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tc1)
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tc1)
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
			 tc1:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,1))
		end
		tc1:CompleteProcedure()   
	end
end
function cm.tgfilter(c,tc)
	return  c~=tc and   c:IsAbleToGrave()
end

function cm.tfilter2(c,code,e,tp,tc)
	return c:IsSetCard(0x3342) and c:IsType(TYPE_FUSION) and c:IsLevelBelow(8) and c:GetCode()~=code
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function cm.filter2(c,e,tp)
	return c:IsFaceup() and ((c:IsSetCard(0x341) and c:IsLevel(8)) or c:GetCode()~=c:GetOriginalCode()) 
		and Duel.IsExistingMatchingCard(cm.tfilter2,tp,LOCATION_GRAVE,0,1,nil,c:GetCode(),e,tp,c)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.chkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil,code,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	   local tc1=sg:GetFirst()
		 if tc1:IsFaceup() and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tc1)
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tc1)
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
			 tc1:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,1))
		end
	end
end
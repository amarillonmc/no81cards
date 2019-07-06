--祈愿！妖幻之翼降诞！
local m=33700780
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.gb then
	   cm.gb=true
	   --exmater  
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	   e2:SetTarget(cm.mattg)
	   e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	   e2:SetTargetRange(0,0)
	   e2:SetValue(cm.matval)
	   Duel.RegisterEffect(e2,0)
	   cm[0]=e2
	   cm[1]=0
	end
end
cm.card_code_list={33700760}
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(33700772)
end
function cm.tgfilter(c,tp)
	return c:IsSetCard(0x344a) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.fufilter(c,e,tp)
	return c:IsSetCard(0x644a) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function cm.matval(e,c,mg)
	return c:IsSetCard(0x644a)
end
function cm.mattg(e,c)
	return c:IsSetCard(0x344a) and c:IsControler(cm[1])
end
function cm.lkfilter(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and c:IsSetCard(0x644a)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,nil,tp)
		and Duel.IsExistingMatchingCard(cm.fufilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	cm[0]:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	cm[1]=tp
	local b2=Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	cm[0]:SetTargetRange(0,0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
	e:SetLabel(op)
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
	   e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
	   e:SetProperty(0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,nil,tp)
		and Duel.IsExistingMatchingCard(cm.fufilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	cm[0]:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	cm[1]=tp
	local b2=Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	if not b1 and not b2 then return end
	local op=e:GetLabel()
	if op==0 and b1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,2,nil,tp)
	   if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=Duel.SelectMatchingCard(tp,cm.fufilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		  Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		  sg:GetFirst():CompleteProcedure()
	   end 
	end
	if op==1 and b2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tc=Duel.SelectMatchingCard(tp,cm.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	   Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
	cm[0]:SetTargetRange(0,0)
end
 
--土著神 都知久
local m=64800026
local cm=_G["c"..m]
function cm.initial_effect(c)
 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon2)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
 --to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.tdcon1)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.eqfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(8)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  and aux.disfilter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			Duel.NegateRelatedChain(ec,RESET_TURN_SET)
			--equip limit
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_EQUIP_LIMIT)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetLabelObject(tc)
			e0:SetValue(cm.eqlimit)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function cm.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()  and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil,tp) and eg:Filter(cm.tgfilter,nil,tp):GetCount()==1
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  eg:IsExists(cm.tgfilter,1,nil,tp) end
	 Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),tp,LOCATION_GRAVE)
end
function cm.spfilter2(c,e,tp,mg)
	return  c:IsType(TYPE_SYNCHRO) and mg:IsExists(Card.IsCode,1,nil,c:GetCode())  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)   
end
function cm.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE)  and not c:IsImmuneToEffect(e) and c:IsControler(tp) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra() 
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tg=eg:Filter(cm.filter2,e:GetHandler(),e,tp) 
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tg)
	and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tg):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end


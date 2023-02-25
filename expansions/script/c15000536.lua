local m=15000536
local cm=_G["c"..m]
cm.name="灵核机的灵气·基础"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--p
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.pcon)
	e1:SetTarget(cm.ptg)
	e1:SetOperation(cm.pop)
	c:RegisterEffect(e1)
	--h+m
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,15000536)
	e2:SetCondition(cm.hmcon)
	e2:SetTarget(cm.hmtg)
	e2:SetOperation(cm.hmop)
	c:RegisterEffect(e2)
	--change LV
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.lvcon)
	e3:SetTarget(cm.lvtg)
	e3:SetOperation(cm.lvop)
	c:RegisterEffect(e3)
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000538)~=0
end
function cm.cfilter1(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM) and (c:IsType(TYPE_TUNER) or (c:IsLocation(LOCATION_PZONE) and c:IsSynchroType(TYPE_TUNER))) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c,e,tp,c)
end
function cm.cfilter2(c,e,tp,tc)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel(),Group.FromCards(c,tc))
end
function cm.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_PENDULUM) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000538,0))
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000538,0))
	local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	local lv=g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel()
	g1:Merge(g2)
	if Duel.SendtoExtraP(g1,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			g:GetFirst():CompleteProcedure()
		end
	end
end
function cm.hmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==0
end
function cm.tpfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.thfilter,c:GetControler(),LOCATION_DECK,0,1,nil) and not c:IsForbidden()
end
function cm.hmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.tpfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.hmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.tpfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		local tc=g:GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			tc:RegisterFlagEffect(15000538,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(15000538,1))
			if not (Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e)) then return end
			Duel.BreakEffect()
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.lvfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lvfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,cm.lvfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	e:SetLabelObject(cg:GetFirst())
	Duel.ConfirmCards(1-tp,cg)
	local lv=cg:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	e:SetLabel(Duel.AnnounceLevel(tp,1,12,lv))
end
function cm.change(e,c)
	local code=e:GetLabel()
	return c:GetOriginalCodeRule()==code
end
function cm.chfilter(c,code)
	return c:GetOriginalCodeRule()==code
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabelObject():GetOriginalCodeRule()
	local lv=e:GetLabel()
	local ag=Duel.GetMatchingGroup(cm.chfilter,tp,0xff,0xff,nil,code)
	if ag:GetCount()~=0 then 
		local tc=ag:GetFirst()
		while tc do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			--e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetValue(lv)
			e2:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=ag:GetNext()
		end
	end
end
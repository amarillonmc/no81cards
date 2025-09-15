local m=13000746
local cm=_G["c"..m]
function c13000746.initial_effect(c)
 c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.tdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
end
function cm.synfilter(c)
	return c:IsCanBeSynchroMaterial() and c:IsFaceup() and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_PZONE))
end
function cm.synfilter6(c)
return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function cm.syncon(e,c,smat)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_PZONE+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		return Duel.CheckTunerMaterial(c,smat,cm.synfilter6,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,cm.synfilter6,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1,99,smat,mg)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_PZONE+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,cm.synfilter6,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,cm.synfilter6,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.filter2(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil)
	return eg:IsExists(cm.cfilter,1,nil) and g:GetClassCount(Card.GetCode)>=4 and not eg:IsContains(e:GetHandler())
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function cm.desfilter(c,g)
	return g:IsContains(c)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	  local cg=g:GetFirst():GetColumnGroup()
		local sg=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local hg=sg:Select(tp,1,1,nil)
			if #hg>0 then
				Duel.Destroy(hg:GetFirst(),REASON_EFFECT)
			end
	end
 end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function cm.con(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.cfilter(c)
	return c:IsAbleToDeck()
end
function cm.filter6(c)
	return not c:IsType(TYPE_LINK) and not c:IsType(TYPE_XYZ)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
	local aa=Duel.SendtoDeck(tc,nil,nil,REASON_EFFECT)
	if aa>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.IsExistingMatchingCard(cm.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) then
		   local bb=Duel.SelectMatchingCard(tp,cm.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c):GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(aa)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bb:RegisterEffect(e1)
	end
end
end










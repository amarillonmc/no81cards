local m=53718007
local cm=_G["c"..m]
cm.name="太乙救苦天尊"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(cm.con1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MSET+TIMING_SSET+TIMING_END_PHASE)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,e,tp)
	return c:IsSetCard(0x353c) and c:IsFaceup() and c:IsCanOverlay()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cm.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and aux.IsCodeListed(c,mc:GetCode())
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
			local sc=g:GetFirst()
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,tc)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	return not g:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,53718001,53718002)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,53718001,53718002)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.thfilter(c)
	return c:IsCode(53718001,53718002) and c:IsAbleToHand()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_HAND) then return end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local hg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(m,2)
	opval[off-1]=0
	off=off+1
	if #dg>0  then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=1
		off=off+1
	end
	if #hg>0 then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=hg:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

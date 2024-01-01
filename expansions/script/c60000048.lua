--拉莫 哈伊瓦纳斯的内卫
local m=60000048
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,60000043)
	c:EnableReviveLimit()
	--spsummon limit 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.hspcon)
	e2:SetTarget(cm.hsptg)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	--Invalid object 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--xyz henshin
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.sptg2)
	e4:SetOperation(cm.spop2)
	c:RegisterEffect(e4)
	--resurrection  summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.cost)
	e5:SetCondition(cm.spcon3)
	e5:SetTarget(cm.sptg3)
	e5:SetOperation(cm.spop3)
	c:RegisterEffect(e5)
	--removed
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(function(e)
		return e:GetHandler():IsFaceup()
	end)
	e6:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e6)
end
--spsummon procedure
function cm.hspfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost() 
	and (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)) 
	or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)) 
end
function cm.hspcheck(g)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,10)
end
function cm.hspgcheck(g)
	if g:GetSum(Card.GetLevel)<=10 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,10)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	local g=Duel.GetMatchingGroup(cm.hspfilter,tp,LOCATION_ONFIELD,0,c)
	aux.GCheckAdditional=cm.hspgcheck
	local res=g:CheckSubGroup(cm.hspcheck,2,#g)
	aux.GCheckAdditional=nil
	return res
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.hspfilter,tp,LOCATION_ONFIELD,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=cm.hspgcheck
	local sg=g:SelectSubGroup(tp,cm.hspcheck,true,2,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local sg=e:GetLabelObject()
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	sg:DeleteGroup()
end
--Invalid object 
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsSetCard(0x628) then
		e:SetLabel(1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if e:GetLabel()==1 and tc:IsSetCard(0x628) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--xyz henshin--
function cm.filter(c)
	return c:IsFaceup() and c:IsLevel(10) and c:IsType(TYPE_SYNCHRO)
end
function cm.spfilter2(c,e,tp)
	return c:IsCode(60000049) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		local c=e:GetHandler()
		local dc=Duel.GetFirstTarget()
	   if c:IsRelateToEffect(e) and dc:IsRelateToEffect(e) and not dc:IsImmuneToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c,dc))
		end
	end
end
--resurrection  summon--
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60000047)==0 end
	Duel.RegisterFlagEffect(tp,60000047,RESET_CHAIN,0,1)
end
function cm.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsCode(60000043)
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
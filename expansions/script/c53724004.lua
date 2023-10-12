local m=53724004
local cm=_G["c"..m]
cm.name="迫真空手武神 AKYS"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.lcon)
	e0:SetTarget(cm.ltg)
	e0:SetOperation(Auxiliary.LinkOperation(cm.mfilter,3,3,cm.lcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x11e0+TIMING_MAIN_END)
	e2:SetCondition(cm.hkcon)
	e2:SetTarget(cm.hktg)
	e2:SetOperation(cm.hkop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsHasEffect(53724005) or c:IsLinkRace(RACE_WARRIOR)
end
function cm.lcheck(g)
	return g:Filter(Card.IsType,nil,TYPE_MONSTER):GetClassCount(Card.GetLinkAttribute)==g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
end
function cm.lcon(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkCondition(cm.mfilter,3,3,cm.lcheck)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.ltg(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkTarget(cm.mfilter,3,3,cm.lcheck)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	local mg3=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_SZONE,0,nil)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function cm.hkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.filter2(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.excheckfilter(c,e,tp,code,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsCode(code) and not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_ONFIELD,0,1,nil,code)
end
function cm.excheck(c,e,tp,zone)
	local result=false
	if c:IsType(TYPE_MONSTER) then
		result=result or Duel.IsExistingMatchingCard(cm.excheckfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,53724001,zone)
	end
	if c:IsType(TYPE_SPELL) then
		result=result or Duel.IsExistingMatchingCard(cm.excheckfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,53724002,zone)
	end
	if c:IsType(TYPE_TRAP) then
		result=result or Duel.IsExistingMatchingCard(cm.excheckfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,53724003,zone)
	end
	return result
end
function cm.filter(c,e,tp,zone)
	return c:IsAbleToHand() and cm.excheck(c,e,tp,zone)
end
function cm.hktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.filter(chkc,e,tp) end
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then return c:GetFlagEffect(m)==0 and zone~=0 and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	e:SetLabel(g:GetFirst():GetType())
end
function cm.spopfilter(c,e,tp,typ,zone)
	return (((typ & TYPE_MONSTER)>0 and c:IsCode(53724001))
		or ((typ & TYPE_SPELL)>0 and c:IsCode(53724002))
		or ((typ & TYPE_TRAP)>0 and c:IsCode(53724003)))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
		and not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.hkop(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=c:GetLinkedZone(tp)
	if c:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spopfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,typ,zone)
	if #g>0 and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP,zone) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1,true)
		local fid=c:GetFieldID()
		g:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(g:GetFirst())
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		Duel.RegisterEffect(e2,tp)
		Duel.SpecialSummonComplete()
		if tc:IsRelateToEffect(e) and tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.BreakEffect()
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end

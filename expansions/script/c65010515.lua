--URBEX HINDER-暴食者
function c65010515.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65010515.lcheck)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010515,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65010515)
	e1:SetCondition(c65010515.lkcon)
	e1:SetTarget(c65010515.lktg)
	e1:SetOperation(c65010515.lkop)
	c:RegisterEffect(e1)
end
c65010515.setname="URBEX"
function c65010515.lcfil(c)
	return c.setname=="URBEX"
end
function c65010515.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c65010515.lkfil(c,mc,m)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabel(m)
	e2:SetTarget(c65010515.mattg)
	e2:SetValue(c65010515.matval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local res=c:IsLinkSummonable(nil,mc) and c.setname=="URBEX"
	e2:Reset()
	return res
end
function c65010515.mattg(e,c)
	return c65010515.lafil(c,e:GetHandlerPlayer())
end
function c65010515.matfilter(c,e,tp)
	if not c65010515.lafil(c,tp) then return false end
	local efftable=table.pack(c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL))
	if #efftable==0 then return false end
	for i,v in ipairs(efftable) do
		if v~=e then return false end
	end
	return true
end
function c65010515.matval(e,lc,mg,c,tp)
	if e:GetHandlerPlayer()~=tp then return false,nil end
	return true,not mg or mg:FilterCount(c65010515.matfilter,nil,e,tp)<e:GetLabel()
end

function c65010515.lafil(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==1-tp
end
function c65010515.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local m=e:GetHandler():GetMutualLinkedGroupCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c65010515.lkfil,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),m) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65010515.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local m=e:GetHandler():GetMutualLinkedGroupCount()
	local g=Duel.GetMatchingGroup(c65010515.lkfil,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		--extra material
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabel(m)
		e2:SetTarget(c65010515.mattg)
		e2:SetValue(c65010515.matval)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local re2=Effect.CreateEffect(c)
		re2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		re2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		re2:SetCode(EVENT_MOVE)
		re2:SetLabelObject(e2)
		re2:SetOperation(c65010515.resetop2)
		sg:GetFirst():RegisterEffect(re2)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c65010515.resetop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
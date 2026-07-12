-- 死狱乡的导化 赫灼龙
local s,id,o=GetID()
function s.initial_effect(c)
  c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x164),s.matfilter,true)
  --splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(s.splimit)
	c:RegisterEffect(e2)
	--summon process
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
function s.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetFlagEffect(sp,id)==0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) or c:GetFlagEffect(id)>0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.getrg(tp,sc,rc)
	local rg=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON)
	local mrg=rg:Filter(Card.IsHasEffect,rc,EFFECT_EXTRA_RELEASE)
	if mrg:GetCount()>0 then
		return mrg:Filter(s.spfilter,rc,tp,sc)
	else
		return rg:Filter(s.spfilter,rc,tp,sc)
	end
end
function s.spfilter(c,tp,sc)
	return c:IsFusionSetCard(0x164)
		and (c:IsControler(tp) or c:IsFaceup())
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
		and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.cfilter(c,tp,sc)
  local rg=s.getrg(tp,sc,c)
	return c:IsLevelAbove(8) and c:IsDiscardable(REASON_SPSUMMON)
	    and rg:GetCount()>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
	  local g2=s.getrg(tp,c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tc2=g2:SelectUnselect(nil,tp,false,true,1,1)
		if tc2 then
			tc2:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,0,1)
			local sg=Group.FromCards(tc,tc2)
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		end
	end
	return false
end
function s.disfilter(c)
	return c:GetFlagEffect(id+o)==0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	local g=e:GetLabelObject()
	local dg=g:Filter(s.disfilter,nil)
	g:Sub(dg)
	Duel.SendtoGrave(dg,REASON_SPSUMMON+REASON_DISCARD)
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.spcfilter(c,e,tp)
	return (c:IsSetCard(0x164) or c:IsCode(95515789)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsFaceupEx()
end
function s.setcfilter(c)
	return (c:IsSetCard(0x15d) or c:IsCode(71202121)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.setcfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	elseif op==2 then
		e:SetCategory(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	elseif op==2 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setcfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	  if g:GetCount()>0 then
		  Duel.SSet(tp,g:GetFirst())
	  end
	end
end
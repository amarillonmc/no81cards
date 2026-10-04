--诡灾的命定人 唐翼风
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddMaterialCodeList(c,11772600)
	--融合召唤
	aux.AddFusionProcMix(c,true,true,11772600,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6c77),aux.FilterBoolFunction(Card.IsFusionType,TYPE_DUAL),nil)
	c:EnableReviveLimit()
	--特召标记    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.regcon)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)
	--特召限制    
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--特召规则    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--盖放
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SSET+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetCost(s.setcost)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)   
	--特殊召唤    
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
s.has_text_type=TYPE_DUAL
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) or c:GetFlagEffect(id)>0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetFlagEffect(sp,id)==0
end
function s.sprfilter(c,tp,sc)
	return c:IsControler(tp) and c:IsReleasable(REASON_SPSUMMON) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
    	and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function s.fcfilter1(c,g,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsFusionSetCard(0x6c77) and c~=mc and g:IsExists(Card.IsFusionType,1,mg,TYPE_DUAL)
end
function s.fcfilter2(c,g)
	return c:IsCode(11772600) and g:IsExists(s.fcfilter1,1,c,g,c)
end
function s.hspchk(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:IsExists(s.fcfilter2,1,nil,g)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil,tp,c)
	return rg:CheckSubGroup(s.hspchk,3,3,tp,c) and Duel.GetFlagEffect(tp,id)==0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.hspchk,true,3,3,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.costfilter(c)
	return aux.IsTypeInText(c,TYPE_DUAL) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.setfilter(c)
	if not (aux.IsTypeInText(c,TYPE_DUAL) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return (c:IsAbleToHand() or c:IsSSetable()) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.SSet(tp,tc)~=0 then
            	if tc:IsType(TYPE_QUICKPLAY) then
            		local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(id,2))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1) 
                elseif tc:IsType(TYPE_TRAP) then
                	local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetDescription(aux.Stringid(id,2))
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)                 
                end     
            end
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_NORMAL+TYPE_DUAL)
    	and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.fscfilter(c,g)
	return c:IsType(TYPE_NORMAL) and g:IsExists(Card.IsType,1,c,TYPE_DUAL)
end
function s.fselect(g)
	return g:IsExists(s.fscfilter,1,nil,g) 
end    
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:CheckSubGroup(s.fselect,2,2)
    	and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
    if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2)
    if sg and sg:GetCount()>1 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
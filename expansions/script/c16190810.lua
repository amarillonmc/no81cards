--超跃星★伽妮特·F
local s,id,o=GetID()
function s.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.spcon2)
	c:RegisterEffect(e2)
	--连接召唤    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.lktg)
	e3:SetOperation(s.lkop)
	c:RegisterEffect(e3)
    if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end    
end
function s.checkfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_WARRIOR) and c:IsPreviousControler(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
    	if eg:IsExists(s.checkfilter,1,nil,p) then 
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
        end    
	end
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
        and Duel.GetFlagEffect(tp,id+o)==0 end
    Duel.RegisterFlagEffect(tp,id+o,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rlfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsReleasableByEffect()
end    
function s.fselect(g,mc,sc,tp,lc)
	if not mc:IsLinkState() and Duel.GetLocationCountFromEx(tp,tp,nil,sc)==0 then 
    	return sc:GetLink()-lc:GetLink()>1 and g:IsContains(mc) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
    else    
		return g:IsContains(mc) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 
    end    
end
function s.exfilter(c,lc,ct,e,tp,cg,mc)
	local lk=c:GetLink()-lc:GetLink()
	return c:IsSetCard(0xca0) and c:IsType(TYPE_LINK) and lk>0 and ct>=lk and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
    	and cg:CheckSubGroup(s.fselect,1,cg:GetCount(),mc,c,tp,lc)
end
function s.txfilter(c,e,tp,mc)
	local cg=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_MZONE,0,nil)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0xca0) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,c,cg:GetCount(),e,tp,cg,mc) 
end
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.txfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.txfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,c) 
    	and c:IsReleasableByEffect() and c:IsRace(RACE_WARRIOR) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) 
        and Duel.GetFlagEffect(tp,id+o)==0 end
    Duel.RegisterFlagEffect(tp,id+o,RESET_CHAIN,0,1)    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.txfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,c)
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end    
function s.lkfilter(c,lc,e,tp,link)
	local lk=c:GetLink()-lc:GetLink()
	return c:IsSetCard(0xca0) and c:IsType(TYPE_LINK) and lk==link and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:IsReleasableByEffect() or not c:IsRace(RACE_WARRIOR) then return end
    local tc=Duel.GetFirstTarget() 
    local avail={}
	local availbool={}    
    local cg=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_EXTRA,0,nil,tc,cg:GetCount(),e,tp,cg,c)
    for sc in aux.Next(sg) do
        local lk=sc:GetLink()-tc:GetLink()
        if not availbool[lk] then
			availbool[lk]=true
			table.insert(avail,lk)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
    local uplk=Duel.AnnounceNumber(tp,table.unpack(avail))
    if cg:GetCount()<uplk then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp,uplk):GetFirst()
    if not sc then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=cg:SelectSubGroup(tp,s.fselect,false,uplk,uplk,c,sc,tp,tc)
    if not rg then return end	
	if Duel.Release(rg,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 
    	and tc:IsLocation(LOCATION_EXTRA) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then
    	Duel.BreakEffect()
    	if Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
			sc:CompleteProcedure()
        end    
	end
end
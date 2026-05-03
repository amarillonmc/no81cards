--超跃星★卡妮·R
local s,id,o=GetID()
function s.initial_effect(c)
	--卡组检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
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
end
function s.thfilter(c)
	return c:IsSetCard(0xca0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
    	and Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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
        and Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
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
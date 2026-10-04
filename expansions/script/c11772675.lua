--诡灾终世 世界救赎
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddMaterialCodeList(c,11772670)
    aux.AddCodeList(c,11772600)
    c:SetUniqueOnField(1,0,id)
	--融合召唤
	aux.AddFusionProcMixRep(c,true,true,s.matfilter1,2,2,11772670,s.matfilter2)
	c:EnableReviveLimit()
	--回到手卡	
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCondition(s.bhcon)
    e1:SetTarget(s.bhtg)
	e1:SetOperation(s.bhop)
	c:RegisterEffect(e1)	    
	--回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.txcon)
	e2:SetTarget(s.txtg)
	e2:SetOperation(s.txop)
	c:RegisterEffect(e2)
end
function s.matfilter1(c)
	return c:IsRace(RACE_FAIRY) or c:IsFusionSetCard(0x6c77)
end
function s.matfilter2(c)
	return c:IsFusionSetCard(0x6c77) and c:IsFusionType(TYPE_FUSION)
end
function s.bhcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.fspfilter(c,e,tp,sg)
	return c:IsSetCard(0x6c77) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
    	and c:CheckFusionMaterial() and Duel.GetLocationCountFromEx(tp,tp,sg,c)>0 
end
function s.bhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return hg:GetCount()>0 and Duel.IsExistingMatchingCard(s.fspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,hg)
    	and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,hg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fselect(g,ft1,ft2)
	return g:GetCount()<=ft1 and g:FilterCount(s.exfilter,nil)<=ft2
end
function s.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function s.bhop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    if hg:GetCount()>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then
    	local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
        if oc<=0 then return end       
        local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)
		local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
		local ct=math.min(ft,ect)
        if ct<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
        local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
        local g=Duel.GetMatchingGroup(s.fspfilter,tp,LOCATION_EXTRA,0,nil,e,tp,nil)
        if g:GetCount()<=0 then return end
        if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,s.fselect,false,1,g:GetCount(),ct,ft2)
		if not sg then return end
        for sc in aux.Next(sg) do	
        	sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
                sc:CompleteProcedure()                
            end
		end
    end
end
function s.txcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.tdfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.txtg(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return true end
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_ONFIELD,nil)
    local sg=g+c
    Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.txop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
    	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
    end
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.sythcon)
	e1:SetOperation(s.sythop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.sythfilter(c)
	return c:IsCode(11772600) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.sythcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.sythfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.sythop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.sythfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
	end
end
--救赎的天书
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11771980,11771970)
	--发动    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--破坏	
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--同调召唤 
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)   
end
function s.thfilter(c)
	return aux.IsCodeListed(c,11771980) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.confilter(c)
	return c:IsFaceup() and c:IsCode(11771980)
end    
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,id)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc and Duel.SendtoHand(sc,nil,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,sc)
            if Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,0,1,nil)
            	and Duel.IsPlayerCanDraw(tp,1) then
                Duel.BreakEffect()
                Duel.Draw(tp,1,REASON_EFFECT)
            end
        end   
   	end     
end
function s.cfilter(c)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
    	Duel.Destroy(c,REASON_EFFECT)
   	end     
end        
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE)
end
function s.spfilter(c,e,tp,mc)
	return c:IsCode(11771970) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
    	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end    
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp):Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
		if not sc then return end
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
			sc:CompleteProcedure()							
        end
    end    
end
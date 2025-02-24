--复仇之眼－赫戮斯
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddCodeList(c,11900061)   
	--to grave 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,id) 
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg) 
	e1:SetOperation(s.tgop) 
	c:RegisterEffect(e1) 
	--dis 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,id+10000) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end) 
	e2:SetTarget(s.distg) 
	e2:SetOperation(s.disop) 
	c:RegisterEffect(e2) 
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return not e:GetHandler():IsPublic() end   
end 
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND) 
end 
function s.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(dg,REASON_EFFECT)   
	end 
end 
function s.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_RITUAL) and aux.IsCodeListed(c,11900061)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
    if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.desfilter1(c)
	return c:GetSequence()<5 and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.desfilter2(c,tp)
	return c:IsControler(tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
        Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)   
		local batk=sc:GetBaseAttack()
		local bdef=sc:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(bdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(batk)
		sc:RegisterEffect(e2)
        local g1=Duel.GetMatchingGroup(s.desfilter1,tp,LOCATION_MZONE,0,nil)
        local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE+LOCATION_SZONE,nil)
        if e:GetLabel()==1 and g1:GetCount()>0 and g2:GetCount()>0 then
            local dg=Group.CreateGroup()
            local a=0
            while a<5 do 
                local tc=g1:Filter(function(c,seq) return c:GetSequence()==seq end,nil,a):GetFirst()
                if tc then
                    local sg=tc:GetColumnGroup():Filter(s.desfilter2,nil,1-tp)
                    if sg:GetCount()~=0 then
                        dg:Merge(sg)
                    end
                end
                a=a+1
            end
            if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.SendtoGrave(dg,REASON_EFFECT)
            end
        end
	end
end
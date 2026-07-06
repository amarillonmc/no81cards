--噗啾噗姆★黏糊糊乐园
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--特殊召唤    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--补充超量素材            
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.mtcon)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)    
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ILLUSION)
    	and (c:IsLevel(2) or c:IsRank(2))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and rc:IsRace(RACE_ILLUSION) and rc:IsRank(2)
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ILLUSION) and c:IsType(TYPE_XYZ) and c:IsRank(2)
end
function s.mtfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_EXTRA,0,1,nil,e)
	local b2=Duel.IsExistingMatchingCard(s.mtfilter,tp,0,LOCATION_EXTRA,1,nil,e)
    if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end   
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_EXTRA,0,1,nil,e)
	local b2=Duel.IsExistingMatchingCard(s.mtfilter,tp,0,LOCATION_EXTRA,1,nil,e)
	if b1 and b2 then			
    	op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))	
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local xg=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.HintSelection(xg)
	local xc=xg:GetFirst()
    if op==0 then
    	local g=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_EXTRA,0,nil,e)
		if g:GetCount()>0 then
			local sg=g:Select(tp,1,1,nil)
            local oc=sg:GetFirst()
			Duel.Overlay(xc,oc)
        end
    end        
    if op==1 then
		local g=Duel.GetMatchingGroup(s.mtfilter,tp,0,LOCATION_EXTRA,nil,e)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
            local oc=sg:GetFirst()
			Duel.Overlay(xc,oc)
        end    
	end
end
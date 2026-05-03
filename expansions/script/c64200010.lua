--爱妮慕丝的玩偶 菲叶
local s,id,o=GetID()
function s.initial_effect(c)
	--破坏	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)  
end    
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desfilter(c)
	return c:IsFaceup() and (c:IsLevelBelow(5) or c:IsRankBelow(5))
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(7)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x64a)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)	
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
    	local b1=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil):GetCount()>0
		local b2=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,10,nil)
    		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    	local b3=(b1 and b2)
        if (b1 or b2 or b3) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        	local sel=0
			local ac=0
			if b1 then sel=sel+1 end
			if b2 then sel=sel+2 end
       	 	if sel==1 then
				ac=Duel.SelectOption(tp,aux.Stringid(id,3))
			elseif sel==2 then
				ac=Duel.SelectOption(tp,aux.Stringid(id,4))+1
			elseif b3 then
				ac=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4),aux.Stringid(id,2))
			else
				ac=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
       		end
    		if ac==0 or ac==2 then
    			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil):Select(tp,1,1,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.Destroy(g,REASON_EFFECT)
				end
        	end
       		if ac==1 or ac==2 then
           		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
                end   
			end
		end
	end
end
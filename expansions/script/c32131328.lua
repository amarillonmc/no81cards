--梅比乌斯的超变手术
function c32131328.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c32131328.actg) 
	e1:SetOperation(c32131328.acop) 
	c:RegisterEffect(e1) 
end
c32131328.SetCard_HR_flame13=true  
function c32131328.rlfil(c,e,tp) 
	return c:IsReleasable() and Duel.IsExistingMatchingCard(c32131328.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end 
function c32131328.spfil(c,e,tp,rc) 
	local xcode=c.HR_Flame_CodeList
	return xcode==rc:GetCode() and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0 
end 
function c32131328.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131328.rlfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local rc=Duel.SelectMatchingCard(tp,c32131328.rlfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst() 
	Duel.Release(rc,REASON_COST)
	e:SetLabelObject(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32131328.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local rc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(c32131328.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,rc) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 





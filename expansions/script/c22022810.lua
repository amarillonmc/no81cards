--人理之基 马嘶
function c22022810.initial_effect(c)
	--summon  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_MZONE)
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1) 
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c22022810.valcheck)
	c:RegisterEffect(e2)
	--sum eff 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetLabelObject(e2)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) end)
	e3:SetTarget(c22022810.sumetg) 
	e3:SetOperation(c22022810.sumeop) 
	c:RegisterEffect(e3) 
end
function c22022810.valcheck(e,c)
	local g=c:GetMaterial() 
	local tp=c:GetControler() 
	local mchk1=0 
	local mchk2=0 
	local mchk3=0 
	local tc=g:GetFirst()
	while tc do
	if tc:IsLocation(LOCATION_HAND) then mchk1=1 end 
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then mchk2=1 end 
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(1-tp) then mchk3=1 end 
	tc=g:GetNext()
	end 
	e:SetLabel(mchk1,mchk2,mchk3)
end
function c22022810.sumetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c22022810.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c22022810.sumeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local mchk1,mchk2,mchk3=e:GetLabelObject():GetLabel()  
	if mchk1==1 then 
		if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then 
			local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end 
	end 
	if mchk2==1 then 
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g:GetCount()>0 then 
			local hg=g:RandomSelect(tp,1) 
			Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
		end 
	end 
	if mchk3==1 then 
		if Duel.IsExistingMatchingCard(c22022810.spfil,1-tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(22022790,0)) then 
			local sg=Duel.SelectMatchingCard(1-tp,c22022810.spfil,1-tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
		end 
	end 
end 


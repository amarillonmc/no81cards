--假面骑士 OOO
function c32100002.initial_effect(c)
	c:SetUniqueOnField(1,0,32100002) 
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c32100002.eqtg)
	e1:SetOperation(c32100002.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--eq2 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_EQUIP) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTarget(c32100002.eqtg2) 
	e3:SetOperation(c32100002.eqop2) 
	c:RegisterEffect(e3) 
end
function c32100002.filter1(c)
	return c.SetCard_HR_Corecoin and not c:IsForbidden()
end
function c32100002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c32100002.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c32100002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE) 
	if ft>3 then ft=3 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP) 
	local g=Duel.SelectMatchingCard(tp,c32100002.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil)  
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst()
	while tc do 
		if Duel.Equip(tp,tc,c) then 
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c32100002.eqlimit)
			tc:RegisterEffect(e1)  
		end 
	tc=g:GetNext() 
	end
end
function c32100002.eqlimit(e,c)
	return e:GetOwner()==c
end
function c32100002.filter2(c,e,tp)
	return c.SetCard_HR_Corecoin and not c:IsForbidden() and Duel.GetFlagEffect(tp,32100002+c:GetOriginalCodeRule())==0 
end
function c32100002.eqgck(g,e,tp) 
	return Duel.GetLocationCount(tp,LOCATION_SZONE)+g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)>=g:GetCount() and Duel.IsExistingMatchingCard(c32100002.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,g:GetCount(),nil,e,tp) 
end 
function c32100002.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler() 
	local mg=Duel.GetMatchingGroup(function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin end,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return mg:CheckSubGroup(c32100002.eqgck,1,10,e,tp) and e:GetHandler():GetFlagEffect(32100002)==0 end 
	e:GetHandler():RegisterFlagEffect(32100002,RESET_CHAIN,0,1) 
	local sg=mg:SelectSubGroup(tp,c32100002.eqgck,false,1,10,e,tp) 
	e:SetLabel(Duel.SendtoGrave(sg,REASON_COST))
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,sg:GetCount(),tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c32100002.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=x and Duel.IsExistingMatchingCard(c32100002.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,x,nil,e,tp) then 
		local g=Duel.SelectMatchingCard(tp,c32100002.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,x,x,nil,e,tp) 
		local tc=g:GetFirst()
		while tc do 
		if Duel.Equip(tp,tc,c) then 
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c32100002.eqlimit)
			tc:RegisterEffect(e1)  
			Duel.RegisterFlagEffect(tp,32100002+tc:GetOriginalCodeRule(),RESET_PHASE+PHASE_END,0,1)
		end 
		tc=g:GetNext() 
		end
	end  
end 









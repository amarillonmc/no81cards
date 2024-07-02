--驾驭纹章之力 琉迩
function c75000002.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,75000001,c75000002.ffilter,1,true,true)   
	--equip
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetTarget(c75000002.eqtg)
	e1:SetOperation(c75000002.eqop)
	c:RegisterEffect(e1) 
	--effect gian
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c75000002.efop)
	c:RegisterEffect(e2) 
end
function c75000002.ffilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsLevel(4) 
end 
function c75000002.filter(c)
	return c:IsSetCard(0x751) and not c:IsCode(75000001) and not c:IsForbidden()
end
function c75000002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75000002.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c75000002.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c75000002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c75000002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c75000002.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c75000002.eqlimit(e,c)
	return e:GetOwner()==c  
end
function c75000002.effilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsSetCard(0x751) 
end
function c75000002.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local ct=c:GetEquipGroup() 
	local wg=ct:Filter(c75000002.effilter,nil)   
	local wbc=wg:GetFirst()
	while wbc do   
		local code=wbc:GetOriginalCode()   
		if c:GetFlagEffect(code)==0 then  
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext()
	end  
end




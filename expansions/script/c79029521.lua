--CiNo.69 纹章虚神 沌辉 
function c79029521.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,5)
	c:EnableReviveLimit()
	--God Medallion Hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c79029521.efop)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(c79029521.dstg)
	c:RegisterEffect(e2)	
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c79029521.spcost)
	e4:SetTarget(c79029521.sptg)
	e4:SetOperation(c79029521.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BECOME_TARGET)
	c:RegisterEffect(e5)
end
c79029521.xyz_number=69
function c79029521.effilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c79029521.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ct=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local wg=ct:Filter(c79029521.effilter,c,tp)
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
function c79029521.dstg(e,c)
	return c~=e:GetHandler()
end
function c79029521.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029521.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029521.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and c79029521.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(1-tp)>0
		and Duel.IsExistingTarget(c79029521.filter,tp,0,LOCATION_EXTRA,1,nil,e,tp) end
	local a=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,a)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79029521.filter,tp,0,LOCATION_EXTRA,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79029521.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
	local x=tc:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(x)
	e:GetHandler():RegisterEffect(e1)
	end
end






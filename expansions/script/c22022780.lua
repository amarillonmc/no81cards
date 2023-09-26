--人理之基 迦尔纳
function c22022780.initial_effect(c)
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
	e2:SetValue(c22022780.valcheck)
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
	e3:SetTarget(c22022780.sumetg) 
	e3:SetOperation(c22022780.sumeop) 
	c:RegisterEffect(e3) 
end
function c22022780.valcheck(e,c)
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
function c22022780.sumetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c22022780.sumeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local mchk1,mchk2,mchk3=e:GetLabelObject():GetLabel()  
	if mchk1==1 then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
	if mchk2==1 then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(5000) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
		end 
	end 
	if mchk3==1 then 
		Duel.SetLP(tp,Duel.GetLP(tp)-5000) 
	end 
end 








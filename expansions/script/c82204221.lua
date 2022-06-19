local m=82204221
local cm=_G["c"..m]
cm.name="堕世魔镜-尘寂"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)  
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800) 
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if Duel.Damage(1-tp,800,REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstTarget()  
		if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetValue(RESET_TURN_SET)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then  
				local e3=Effect.CreateEffect(c)  
				e3:SetType(EFFECT_TYPE_SINGLE)  
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
				tc:RegisterEffect(e3)  
			end
		end
	end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)   
	Duel.RegisterEffect(e1,tp)  
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)  
	Duel.RegisterEffect(e3,tp)
end   
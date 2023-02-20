--Lycoris-胡桃支援
function c12852007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12852007.target)
	e1:SetOperation(c12852007.operation)
	c:RegisterEffect(e1)  
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852007.eqlimit)
	c:RegisterEffect(e3)  
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852007,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c12852007.descon)
	e2:SetTarget(c12852007.destg)
	e2:SetOperation(c12852007.desop)
	c:RegisterEffect(e2)  
	--change
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(12852007,1))
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetRange(LOCATION_MZONE)
	e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetTarget(c12852007.chtg)
	e21:SetOperation(c12852007.chop)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e32:SetRange(LOCATION_SZONE)
	e32:SetTargetRange(LOCATION_MZONE,0)
	e32:SetTarget(c12852007.eftg)
	e32:SetLabelObject(e21)
	c:RegisterEffect(e32)  
end
function c12852007.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852007.desfilter2(c,col,tp,e)
	return  col==aux.GetColumn(c) and c:IsControler(tp)  and c:IsSetCard(0xa75) and not c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852007.descon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c12852007.desfilter2,1,e:GetHandler(),col,tp,e)
end
function c12852007.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local col=aux.GetColumn(e:GetHandler())
	if chk==0 then return e:GetHandler():GetFlagEffect(12852007)==0  end
	e:GetHandler():RegisterFlagEffect(12852007,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local og=eg:Filter(c12852007.desfilter2,nil,col,tp,e)
	og:KeepAlive()
	e:SetLabelObject(og)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852007.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=aux.GetColumn(e:GetHandler())
	local tc=e:GetLabelObject():GetFirst()
	if not tc then return end
	if c:IsRelateToEffect(e)  and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852007.eqlimit(e,c)
	return c:IsSetCard(0xa75)
end
function c12852007.filter(c,tp,e)
	return (c:IsFaceup() and c:IsSetCard(0xa75) and c:IsControler(tp))
end
function c12852007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852007.filter,tp,LOCATION_MZONE,0,1,nil,tp,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852007.filter,tp,LOCATION_MZONE,0,1,1,nil,tp,e)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852007.desfilter(c,tp,e)
	return c:IsControler(1-tp)
end
function c12852007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=c:GetSequence()
	if tc:IsControler(tp) then
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			if  Duel.Equip(tp,c,tc)~=0 and Duel.IsExistingMatchingCard(c12852007.desfilter,tp,0,LOCATION_MZONE,1,nil,tp,e) and Duel.SelectYesNo(tp,aux.Stringid(12852007,0)) then
				Duel.BreakEffect()
				local cc=Duel.SelectMatchingCard(tp,c12852007.desfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,e):GetFirst()
				cc:RegisterFlagEffect(12852107,RESET_EVENT+RESETS_STANDARD,0,1)
				--add setcode
				local e11=Effect.CreateEffect(c)
				e11:SetType(EFFECT_TYPE_FIELD)
				e11:SetCode(EFFECT_ADD_SETCODE)
				e11:SetValue(0xa75)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				e11:SetTarget(c12852007.disable)
				e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e11:SetRange(LOCATION_SZONE)
				c:RegisterEffect(e11)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetRange(LOCATION_SZONE)
				e1:SetTarget(c12852007.disable)
				e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetRange(LOCATION_SZONE)
				e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e2:SetTarget(c12852007.disable)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
				--control
				local e21=Effect.CreateEffect(c)
				e21:SetType(EFFECT_TYPE_FIELD)
				e21:SetCode(EFFECT_SET_CONTROL)
				e21:SetValue(tp)
				e21:SetRange(LOCATION_SZONE)
				e21:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e21:SetTarget(c12852007.disable)
				e21:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e21)
			end
		end
	end
end
function c12852007.disable(e,c)
	return c:GetFlagEffect(12852107)>0
end
function c12852007.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa75) and c:GetSequence()<5
end
function c12852007.fselect(g,c)
	return g:IsContains(c)
end
function c12852007.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12852007.chfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c12852007.fselect,2,2,e:GetHandler()) and Duel.GetFlagEffect(tp,c:GetCode()+100000)==0  end
	Duel.RegisterFlagEffect(tp,c:GetCode()+100000,RESET_PHASE+PHASE_END,0,1)
end
function c12852007.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c12852007.chfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c12852007.fselect,false,2,2,c)
	if sg and sg:GetCount()==2 then
		Duel.HintSelection(sg)
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SwapSequence(tc1,tc2)
		local tc=tc1
		if tc==c then tc=tc2 end
	end
end
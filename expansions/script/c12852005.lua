--Lycoris-应急处理
function c12852005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12852005.target)
	e1:SetOperation(c12852005.operation)
	c:RegisterEffect(e1)   
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852005.eqlimit)
	c:RegisterEffect(e3)  
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852005,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c12852005.descon)
	e2:SetTarget(c12852005.destg)
	e2:SetOperation(c12852005.desop)
	c:RegisterEffect(e2)
	--turnset
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(12852005,0))
	e21:SetCategory(CATEGORY_POSITION)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e21:SetCode(EVENT_ATTACK_ANNOUNCE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCondition(c12852005.pdcon)
	e21:SetTarget(c12852005.pdtg)
	e21:SetOperation(c12852005.pdop)
	c:RegisterEffect(e21)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e32:SetRange(LOCATION_SZONE)
	e32:SetTargetRange(LOCATION_MZONE,0)
	e32:SetTarget(c12852005.eftg)
	e32:SetLabelObject(e21)
	c:RegisterEffect(e32)
end
function c12852005.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852005.desfilter(c,col,tp,e)
	return col==aux.GetColumn(c) and c:IsControler(tp) and c:IsSetCard(0xa75) and not c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852005.descon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c12852005.desfilter,1,e:GetHandler(),col,tp,e)
end
function c12852005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local col=aux.GetColumn(e:GetHandler())
	local og=eg:Filter(c12852005.desfilter,nil,col,tp,e)
	if chk==0 then return e:GetHandler():GetFlagEffect(12852005)==0 and og:GetCount()~=0 end
	e:GetHandler():RegisterFlagEffect(12852005,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	og:KeepAlive()
	e:SetLabelObject(og)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852005.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=aux.GetColumn(e:GetHandler())
	local tc=e:GetLabelObject():GetFirst()
	if not tc then return end
	if c:IsRelateToEffect(e)  and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852005.eqlimit(e,c)
	return c:IsSetCard(0xa75)
end
function c12852005.filter(c,e,tp,zone)
	return c:IsFaceup() and c:IsSetCard(0xa75) and c:IsControler(tp) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) or c:IsLocation(LOCATION_MZONE)) 
end
function c12852005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=1<<(e:GetHandler():GetSequence())
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c12852005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852005.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c12852005.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852005.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=1<<(e:GetHandler():GetSequence())
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
			Duel.SpecialSummon(tc,SUMMON_VALUE_MONSTER_REBORN,tp,tp,false,false,POS_FACEUP,zone)
		end
		Duel.Equip(tp,c,tc)
	end
end
function c12852005.pdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c12852005.pdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttacker():IsRelateToBattle() and Duel.GetAttacker():IsCanTurnSet() and Duel.GetFlagEffect(tp,c:GetCode()+1000)==0 end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,Duel.GetAttacker(),1,0,0)
	Duel.RegisterFlagEffect(tp,c:GetCode()+1000,RESET_PHASE+PHASE_END,0,1)
end
function c12852005.pdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToBattle() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end) and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
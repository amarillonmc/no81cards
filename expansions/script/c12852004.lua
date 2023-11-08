--Lycoris-真实武器
function c12852004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12852004.target)
	e1:SetOperation(c12852004.operation)
	c:RegisterEffect(e1)	
	--spsummon1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12852004,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c12852004.spcon1)
	e4:SetTarget(c12852004.sptg1)
	e4:SetOperation(c12852004.spop1)
	c:RegisterEffect(e4)	
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852004,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c12852004.descon)
	e2:SetTarget(c12852004.destg1)
	e2:SetOperation(c12852004.desop1)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852004.eqlimit)
	c:RegisterEffect(e3)
	--destroy
	local e31=Effect.CreateEffect(c)
	e31:SetDescription(aux.Stringid(12852004,1))
	e31:SetCategory(CATEGORY_DESTROY)
	e31:SetType(EFFECT_TYPE_QUICK_O)
	e31:SetCode(EVENT_FREE_CHAIN)
	e31:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e31:SetRange(LOCATION_MZONE)
	e31:SetTarget(c12852004.destg)
	e31:SetOperation(c12852004.desop)
	c:RegisterEffect(e31)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e32:SetRange(LOCATION_SZONE)
	e32:SetTargetRange(LOCATION_MZONE,0)
	e32:SetTarget(c12852004.eftg)
	e32:SetLabelObject(e31)
	c:RegisterEffect(e32)
end
function c12852004.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852004.eqlimit(e,c)
	return c:IsSetCard(0xa75)
end
function c12852004.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa75)
end
function c12852004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852004.chfilter(c)
	return c:IsFaceup() and c:IsCode(12852001)
end
function c12852004.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12852004.chfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12852004.spfilter1(c,e,tp,zone)
	return c:IsCode(12852001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c12852004.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local zone=1<<(e:GetHandler():GetSequence())
		return Duel.IsExistingMatchingCard(c12852004.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12852004.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=1<<e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12852004.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c12852004.desfilter(c,col,tp,e)
	return col==aux.GetColumn(c) and c:IsControler(tp) and c:IsSetCard(0xa75)  and not c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852004.descon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c12852004.desfilter,1,e:GetHandler(),col,tp,e)
end
function c12852004.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local col=aux.GetColumn(e:GetHandler())
	if chk==0 then return e:GetHandler():GetFlagEffect(12852004)==0  end
	e:GetHandler():RegisterFlagEffect(12852004,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local og=eg:Filter(c12852004.desfilter,nil,col,tp,e)
	og:KeepAlive()
	e:SetLabelObject(og)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852004.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=aux.GetColumn(e:GetHandler())
	local tc=e:GetLabelObject():GetFirst()
	if not tc then return end 
	if c:IsRelateToEffect(e)  and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,c:GetCode()+10)==0  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.RegisterFlagEffect(tp,c:GetCode()+10,RESET_PHASE+PHASE_END,0,1)
end
function c12852004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
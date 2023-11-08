--Lycoris-橡胶子弹
function c12852003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12852003.target)
	e1:SetOperation(c12852003.operation)
	c:RegisterEffect(e1)	
	--spsummon1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12852003,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c12852003.spcon1)
	e4:SetTarget(c12852003.sptg1)
	e4:SetOperation(c12852003.spop1)
	c:RegisterEffect(e4)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852003,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c12852003.descon)
	e2:SetTarget(c12852003.destg)
	e2:SetOperation(c12852003.desop)
	c:RegisterEffect(e2)
	--tohand
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(12852003,1))
	e21:SetCategory(CATEGORY_TOHAND)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetTarget(c12852003.thtg)
	e21:SetOperation(c12852003.thop)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e32:SetRange(LOCATION_SZONE)
	e32:SetTargetRange(LOCATION_MZONE,0)
	e32:SetTarget(c12852003.eftg)
	e32:SetLabelObject(e21)
	c:RegisterEffect(e32)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852003.eqlimit)
	c:RegisterEffect(e3)
end
function c12852003.eqlimit(e,c)
	return c:IsSetCard(0xa75)
end
function c12852003.desfilter(c,col,tp,e)
	return col==aux.GetColumn(c) and c:IsControler(tp) and c:IsSetCard(0xa75) and not c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852003.descon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c12852003.desfilter,1,e:GetHandler(),col,tp,e)
end
function c12852003.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local col=aux.GetColumn(e:GetHandler())
	if chk==0 then return e:GetHandler():GetFlagEffect(12852003)==0  end
	e:GetHandler():RegisterFlagEffect(12852003,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local og=eg:Filter(c12852003.desfilter,nil,col,tp,e)
	og:KeepAlive()
	e:SetLabelObject(og)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852003.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=aux.GetColumn(e:GetHandler())
	local tc=e:GetLabelObject():GetFirst()
	if not tc then return end
	if c:IsRelateToEffect(e)  and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852003.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa75)
end
function c12852003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852003.chfilter(c)
	return c:IsFaceup() and c:IsCode(12852002)
end
function c12852003.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12852003.chfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12852003.spfilter1(c,e,tp,zone)
	return c:IsCode(12852002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c12852003.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local zone=1<<(e:GetHandler():GetSequence())
		return Duel.IsExistingMatchingCard(c12852003.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12852003.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=1<<e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12852003.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c12852003.thfilter(c)
	return c:IsAbleToHand() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c12852003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12852003.thfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,c:GetCode()+100)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.RegisterFlagEffect(tp,c:GetCode()+100,RESET_PHASE+PHASE_END,0,1)
end
function c12852003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c12852003.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c12852003.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler())
end
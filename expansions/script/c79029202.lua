--巴别塔·萨卡兹雇佣兵-W
function c79029202.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c79029202.spcon)
	e2:SetTarget(c79029202.sptg)
	e2:SetOperation(c79029202.spop)
	c:RegisterEffect(e2)  
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c79029202.conop)
	c:RegisterEffect(e3)
	e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--des
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)   
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_TURN_END)
	e6:SetOperation(c79029202.desop)
	c:RegisterEffect(e6)
	--equip
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e7:SetTarget(c79029202.eqtg)
	e7:SetOperation(c79029202.eqop)
	c:RegisterEffect(e7)
end
function c79029202.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp,g)>0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,5,nil)
end
function c79029202.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,5,5,nil)
	if g then
	   g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c79029202.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	g:DeleteGroup()
end
function c79029202.conop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	local tc=g:GetFirst()
	while tc do
	tc:AddCounter(0x1099,1)
	tc=g:GetNext()
end
end
function c79029202.desfil(c)
	return c:GetCounter(0x1099)~=0
end
function c79029202.desop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029202.desfil,tp,0,LOCATION_MZONE,nil)
	Duel.Damage(1-tp,g:GetSum(Card.GetAttack),REASON_EFFECT)
	if Duel.Destroy(g,REASON_EFFECT)~=g:GetCount() then
	Duel.GetControl(g,tp)
end
end
function c79029202.eqfil(c)
	return c:IsFaceup() and c:IsCode(79020007)
end
function c79029202.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79029202.eqfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c79029202.eqfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029202.eqfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029202.eqop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c79029202.eqlimit)
	c:RegisterEffect(e3)
	if Duel.Equip(tp,c,tc)~=0 then  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SPELL+TYPE_EQUIP)
	e1:SetReset(RESET_EVENT+EVENT_REMOVE)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetEquipTarget():GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x1901)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
end
function c79029202.eqlimit(e,c)
	return c:IsCode(79020007)
end





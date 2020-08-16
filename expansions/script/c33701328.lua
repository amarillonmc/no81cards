--自食其桃
function c33701328.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701328,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33701328)
	e1:SetCondition(c33701328.condition)
	e1:SetTarget(c33701328.target)
	e1:SetOperation(c33701328.operation)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701328,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,03701328)
	e1:SetCondition(c33701328.condition1)
	e1:SetTarget(c33701328.target1)
	e1:SetOperation(c33701328.operation1)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701328,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,00701328)
	e1:SetTarget(c33701328.eqtg)
	e1:SetOperation(c33701328.eqop)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c33701328.damop)
	c:RegisterEffect(e2)
end
function c33701328.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()~=e:GetHandler():GetEquipTarget() and Duel.GetAttackTarget()~=e:GetHandler():GetEquipTarget() then return end
	Duel.ChangeBattleDamage(tp,0)
end
function c33701328.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(e:GetHandlerPlayer())
end
function c33701328.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackAbove,tp,0,LOCATION_MZONE,1,nil,e,tp,0) end
	Duel.ConfirmCards(tp,e:GetHandler())
	local g=eg:GetFirst():GetReasonCard()
	Duel.SetTargetCard(g)
end
function c33701328.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(0)
	tc:RegisterEffect(e1)
end
function c33701328.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)>0 and eg:FilterCount(Card.IsReason,nil,REASON_EFFECT)>0 and eg:FilterCount(Card.IsReason,nil,REASON_DESTROY)>0 and eg:FilterCount(Card.IsControler,nil,tp)>0
end
function c33701328.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackAbove,tp,0,LOCATION_MZONE,1,nil,e,tp,0) end
	Duel.ConfirmCards(tp,e:GetHandler())
	local g=Duel.GetMatchingGroup(Card.IsAttackAbove,tp,0,LOCATION_MZONE,nil,e,tp,0)
	Duel.SetTargetCard(g)
end
function c33701328.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-1000)
	tc:RegisterEffect(e1)   
	tc=g:GetNext()
	end
end
function c33701328.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,tp,0)
end
function c33701328.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
	e1:SetValue(c33701328.eqlimit)
	c:RegisterEffect(e1)

end
function c33701328.eqlimit(e,c)
	return e:GetOwner()==c
end




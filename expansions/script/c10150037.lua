--蛇毒绿蛇
function c10150037.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150037,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10150037)
	e1:SetTarget(c10150037.tg)
	e1:SetOperation(c10150037.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10150037,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,10150137)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c10150037.destg)
	e4:SetOperation(c10150037.desop)
	c:RegisterEffect(e4)  
end
function c10150037.filter(c)
	return c:IsSetCard(0x50) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(10150037)
end
function c10150037.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150037.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10150037.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10150037.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c10150037.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x50)
end

function c10150037.filter2(c)
	return c:IsFaceup() and c:GetCounter(0x1009)>0 and c:IsDestructable()
end

function c10150037.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10150037.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c10150037.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g1=Duel.SelectTarget(tp,c10150037.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,c10150037.filter1,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end

function c10150037.desop(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	   local tc1=e:GetLabelObject()
	   local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	   local tc2=g:GetFirst()
	  if tc1==tc2 then tc2=g:GetNext() end
	   if tc2:IsRelateToEffect(e) and Duel.Destroy(tc2,REASON_EFFECT)~=0 and tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:GetBaseAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc2:GetBaseAttack())
		tc1:RegisterEffect(e1)
	   end
end

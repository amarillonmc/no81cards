--真祖·太阳神
function c9950459.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,10000010,aux.FilterBoolFunction(Card.IsRace,RACE_DIVINE),1,true,true)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9950459.efilter)
	c:RegisterEffect(e2)
 --atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c9950459.valcheck)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9950459.atkcon)
	e2:SetOperation(c9950459.atkop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
 --atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(9950459,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9950459.atkcost)
	e3:SetOperation(c9950459.atkop2)
	c:RegisterEffect(e3)
 --tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950459,3))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e4:SetCost(c9950459.tgcost)
	e4:SetTarget(c9950459.tgtg)
	e4:SetOperation(c9950459.tgop)
	c:RegisterEffect(e4)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950459.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950459.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950459,0))
end 
function c9950459.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9950459.valcheck(e,c)
	local g=c:GetMaterial()
	local atk=0
	for tc in aux.Next(g) do
		atk=atk+tc:GetOriginalLevel()
	end
	e:SetLabel(atk)
end
function c9950459.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c9950459.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetLabel()*500
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c9950459.cfilter(c)
	return c:GetAttack()>0 and c:IsAbleToRemoveAsCost()
end
function c9950459.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950459.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950459.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c9950459.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950459,1))
end
function c9950459.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9950459.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		local atk=g:GetFirst():GetTextAttack()
		if atk<0 then atk=0 end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	end
end
function c9950459.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950459,1))
end
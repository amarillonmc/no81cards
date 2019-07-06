--偶像部虚拟主播 夜樱 灵
function c33700794.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c33700794.sprcon)
	e1:SetOperation(c33700794.sprop)
	c:RegisterEffect(e1)  
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700794,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c33700794.atktg)
	e2:SetOperation(c33700794.atkop)
	c:RegisterEffect(e2)  
end
function c33700794.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and Duel.IsExistingMatchingCard(c33700794.tgfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c33700794.tgfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk-1)
end
function c33700794.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:IsRelateToBattle() and Duel.NegateAttack() then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local g=Duel.SelectMatchingCard(tp,c33700794.tgfilter,tp,0,LOCATION_MZONE,1,4,nil,atk)
	   if g:GetCount()>0 then
		  Duel.SendtoGrave(g,REASON_EFFECT)
	   end
	end
end
function c33700794.thfilter(c,tp)
	return c33700794.thfilter2(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c33700794.thfilter2(c)
	return c:IsFaceup() and not c:IsSummonableCard() and c:IsAbleToHandAsCost()
end
function c33700794.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c33700794.thfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c33700794.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700794.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if Duel.IsExistingMatchingCard(c33700794.thfilter2,tp,LOCATION_MZONE,0,1,g:GetFirst()) and Duel.SelectYesNo(tp,aux.Stringid(33700794,0)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	   local g2=Duel.SelectMatchingCard(tp,c33700794.thfilter2,tp,LOCATION_MZONE,0,1,99,g:GetFirst())
	   g:Merge(g2)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(g:GetCount()*1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
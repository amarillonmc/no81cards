--龙仪巧-天龙流星=GDR
function c98920277.initial_effect(c) 
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c98920277.valcheck)
	c:RegisterEffect(e0)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c98920277.dircon)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c98920277.matcon)
	e3:SetOperation(c98920277.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
   --damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(c98920277.rdcon)
	e4:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e4)
	--battle1
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(98920277,2))
	e13:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_BATTLE_DAMAGE)
	e13:SetCondition(c98920277.thcon)
	e13:SetTarget(c98920277.thtg)
	e13:SetOperation(c98920277.thop)
	c:RegisterEffect(e13)
	--discard
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98920277,3))
	e11:SetCategory(CATEGORY_HANDES)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_BATTLE_DAMAGE)
	e11:SetCondition(c98920277.condition)
	e11:SetTarget(c98920277.target)
	e11:SetOperation(c98920277.operation)
	c:RegisterEffect(e11)
end
function c98920277.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c98920277.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c98920277.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98920277.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c98920277.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920277,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920277,1))
end
function c98920277.dircon(e)
	return e:GetHandler():GetFlagEffect(98920277)>0
end
function c98920277.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c98920277.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c98920277.filter(c)
	return c:IsAttack(2000) or c:IsAttack(4000) and c:IsAbleToHand()
end
function c98920277.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920277.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,98920274)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,98920274,RESET_CHAIN,0,1)
end
function c98920277.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920277.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920277.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c98920277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,98920274)==0 end
	Duel.RegisterFlagEffect(tp,98920274,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c98920277.operation(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	 local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	 Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
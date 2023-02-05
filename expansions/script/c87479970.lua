--究极宝玉的先导者
function c87479970.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1034),2,true)
	aux.AddContactFusionProcedure(c,aux.TRUE,LOCATION_ONFIELD,0,c87479970.descfop(c))
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c87479970.splimit)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c87479970.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87479970,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c87479970.cost)
	e3:SetTarget(c87479970.target)
	e3:SetOperation(c87479970.operation)
	c:RegisterEffect(e3)
end
--Destroy of contact fusion
function c87479970.descfop(c)
	return  function(g)
				Duel.Destroy(g,nil,REASON_COST)
			end
end
function c87479970.splimit(e,se,sp,st)
	return not (e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFacedown())
end
function c87479970.tgtg(e,c)
	return c:IsSetCard(0x1034) or (c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x2034))
end
function c87479970.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c87479970.filter(c)
	return ((c:IsSetCard(0x1034,0x2034) and c:IsType(TYPE_MONSTER))
		or (c:IsSetCard(0x34) and c:IsType(TYPE_SPELL+TYPE_TRAP))) and c:IsAbleToHand()
end
function c87479970.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87479970.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87479970.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87479970.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

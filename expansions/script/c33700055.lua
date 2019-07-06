--动物朋友 薮猫
function c33700055.initial_effect(c)
	c33700055[c]={}
	local effect_list=c33700055[c]
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41940225,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c33700055.thcost)
	e1:SetTarget(c33700055.thtg)
	e1:SetOperation(c33700055.thop)
	c:RegisterEffect(e1)
   --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetLabel(3)
	effect_list[3]=e2
	e2:SetValue(1)
	e2:SetCondition(c33700055.effcon)
	c:RegisterEffect(e2)
   --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33700055.effcon)
	e3:SetLabel(7)
	effect_list[7]=e3
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33700055.effcon)
	e4:SetLabel(15)
	effect_list[15]=e4
	e4:SetValue(c33700055.efilter)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_BASE_ATTACK)
	e5:SetValue(3000)
	e5:SetCondition(c33700055.effcon2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e6)
end
function c33700055.filter(c)
	return c:IsSetCard(0x442) and c:IsDiscardable() and 
	not c:IsCode(33700055)
end
function c33700055.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700055.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c33700055.filter,1,1,REASON_COST)
end
function c33700055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33700055.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c33700055.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700055.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700055.effcon(e)
	local g=Duel.GetMatchingGroup(c33700055.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090
end
function c33700055.efilter(e,te)
	return  te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c33700055.effcon2(e)
	local g=Duel.GetMatchingGroup(c33700055.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=21
end
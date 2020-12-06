--虚拟YouTuber 未来明 ～NEW WORLD～
function c33710922.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,4,6,c33710922.ovfilter,aux.Stringid(33710922,0),6,c33710922.xyzop)
	c:EnableReviveLimit() 
	--Data up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33710922,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33710922.cost1)
	e1:SetTarget(c33710922.tg1)
	e1:SetOperation(c33710922.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33710922.tgcon)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immue
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c33710922.efcon)
	e4:SetValue(c33710922.efilter)
	c:RegisterEffect(e4)
end
function c33710922.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:GetLevel()>=7
end
function c33710922.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_TOKEN) end
end
function c33710922.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local sum=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return e:GetHandler():GetOverlayCount()>0
		and e:GetHandler():CheckRemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST)
	local sum1=e:GetHandler():GetOverlayGroup():GetCount()
	e:SetLabel((sum-sum1)*500)
end
function c33710922.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end
end
function c33710922.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(num)
	c:RegisterEffect(e1) 
end
function c33710922.tgcon(e)
	return e:GetHandler():IsAttackPos() and e:GetHandler():GetOverlayCount()>0
end
function c33710922.efcon(e)
	return e:GetHandler():IsDefensePos() and e:GetHandler():GetOverlayCount()==0
end
function c33710922.efilter(e,te)
	return te:GetHandler()~=e:GetHandler()
end
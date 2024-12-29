--大海爬兽 多鳞巨蜥

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11602000,aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),1,true,true)
	
	--DestroyTargetThenEffectDemage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.e2efilter)
	c:RegisterEffect(e2)
	
end

--e1
--DestroyTargetThenEffectDemage

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	if not Duel.Destroy(tc,REASON_EFFECT) then return end
	
	if tc:IsLocation(LOCATION_MZONE) then return end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	
	if tc:IsType(TYPE_MONSTER) and tc:GetAttack()>0 then
	    Duel.Damage(1-tp,math.floor(tc:GetAttack()/2),REASON_EFFECT)
	end
end

--e2

function s.e2efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
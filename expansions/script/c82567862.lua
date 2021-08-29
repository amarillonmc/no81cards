--方舟骑士·龙城赤霄 陈
function c82567862.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c82567862.lcheck)
	c:EnableReviveLimit()
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c82567862.atkcon)
	e1:SetTarget(c82567862.atktg)
	e1:SetValue(1400)
	c:RegisterEffect(e1)
	--indestrucble
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567862,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82567862)
	e3:SetTarget(c82567862.adtg)
	e3:SetOperation(c82567862.adop)
	c:RegisterEffect(e3)
	--attack 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetValue(c82567862.atktval)
	c:RegisterEffect(e4)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567862.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x825)
end
function c82567862.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c82567862.atktg(e,c)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return c==e:GetHandler() or g:IsContains(c)
end
function c82567862.filter(c,e)
	local g=e:GetHandler():GetLinkedGroup()
	return g:IsContains(c) and c:IsPosition(POS_ATTACK)
end
function c82567862.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567862.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
end
function c82567862.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82567862.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local tc=g:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	while tc do   
	  tc:AddCounter(0x5825,1)
	 tc=g:GetNext()
	end
end
function c82567862.atktval(e,c,tp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)-1
end
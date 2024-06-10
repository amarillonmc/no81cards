--动物朋友虚拟化
function c33703021.initial_effect(c)
--「动物朋友虚拟化」在自己场上只能有1张表侧表示存在。
	c:SetUniqueOnField(1,0,33703021)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--自己场上·墓地只有「动物朋友」卡存在的状态，有「动物朋友」怪兽送去墓地的场合，自己回复那些怪兽的攻击力总和的基本分。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c33703021.condition)
	e2:SetTarget(c33703021.target)
	e2:SetOperation(c33703021.activate)
	c:RegisterEffect(e2)
end
function c33703021.confilter(c)
	return not c:IsSetCard(0x442)
end
function c33703021.conditon()
	return Duel.IsExistingMatchingCard(c33703021.confilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c33703021.tgfilter(c,tp)
	return c:IsSetCard(0x442) and c:IsLocation(LOCATION_GRAVE)
end
function c33703021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and re:IsActiveType(TYPE_MONSTER) and eg:IsExists(c33703021.tgfilter,1,nil,tp) end
	local g=eg:Filter(c33703021.nil,tp)
	local tc=g:GetFirst()
	while tc do 
		num=tc:GetAttack()
		Duel.Recover(tp,num,REASON_EFFECT)
	end
end
function c33703021.value(e,c)
	return false
end
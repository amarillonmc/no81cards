--无限可能性
function c65130333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130333,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,65130328+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65130333.target)
	e1:SetOperation(c65130333.activate)
	c:RegisterEffect(e1)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c65130333.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(65130303,65130304) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c65130333.cfilter(c)
	return c:IsCode(65130303,65130304) and c:IsAttack(878) and c:IsDefense(1157)
end
function c65130333.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65130333.cfilter,tp,LOCATION_MZONE,0,1,nil,65130303,65130304) and Duel.IsExistingMatchingCard(c65130333.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	--Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c65130333.activate(e,tp,eg,ep,ev,re,r,rp)
	if not KOISHI_CHECK then return end
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c65130333.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)then return end
	local g=Duel.GetMatchingGroup(c65130333.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65130333,1))
		local cg=Duel.SelectMatchingCard(tp,c65130333.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		local cc=cg:GetFirst()
		local cid=cc:GetOriginalCode()
		tc:SetEntityCode(cid,true)
		tc:ReplaceEffect(cid,0,0)
		tc:ResetFlagEffect(65130303)
		tc:RegisterFlagEffect(65130333,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.Hint(HINT_CARD,0,cid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(878)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(1157)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
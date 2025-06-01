--人理之诗 鼠净土
function c22023130.initial_effect(c)
	aux.AddCodeList(c,22023120) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023130,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22023130)
	e2:SetTarget(c22023130.destg)
	e2:SetOperation(c22023130.desop)
	c:RegisterEffect(e2)
	--atk&def
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023130,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22023131)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22023130.adtg)
	e3:SetOperation(c22023130.adop)
	c:RegisterEffect(e3)
end
function c22023130.desfilter(c)
	return c:IsFaceup() and (c:GetAttack()<c:GetBaseAttack() or c:GetDefense()<c:GetBaseDefense())
end
function c22023130.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023130.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22023130.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22023130.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22023130.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c22023130.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c22023130.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023130.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local ct=Duel.GetMatchingGroupCount(c22023130.filter,tp,LOCATION_MZONE,0,nil)
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,22023120) and Duel.SelectYesNo(tp,aux.Stringid(22023130,2)) then
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(ct*200)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				sc:RegisterEffect(e2)
				sc=g:GetNext()
			end
		else
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(ct*100)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				sc:RegisterEffect(e2)
				sc=g:GetNext()
			end
		end
	end
end

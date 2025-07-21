--珊海的妖灭者 伊利奥纳
function c67201419.initial_effect(c)
	--synchro summon
	aux.AddFusionProcCodeFun(c,67201405,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3675),1,true,true)
	c:EnableReviveLimit()  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67201419)
	e1:SetCondition(c67201419.eqcon)
	e1:SetTarget(c67201419.eqtg)
	e1:SetOperation(c67201419.eqop)
	c:RegisterEffect(e1)	  
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c67201419.disop)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
--
function c67201419.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c67201419.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
end
function c67201419.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() then return end
	local tc=eg:GetFirst()
	if tc then
		tc:CancelToGrave()
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c67201419.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c67201419.eqlimit(e,c)
	return e:GetOwner()==c
end
--
function c67201419.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	if ep~=tp and g:GetCount()>0 and g:IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode()) then
	   Duel.NegateEffect(ev)
	end
end




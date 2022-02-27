--珊海环的灭妖者 伊利奥纳
function c67200514.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c67200514.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x675),1,1)
	c:EnableReviveLimit()  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	--e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200514)
	e1:SetCondition(c67200514.eqcon)
	e1:SetTarget(c67200514.eqtg)
	e1:SetOperation(c67200514.eqop)
	c:RegisterEffect(e1)	  
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c67200514.disop)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function c67200514.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x675)
end
--
function c67200514.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c67200514.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
end
function c67200514.eqop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetValue(c67200514.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c67200514.eqlimit(e,c)
	return e:GetOwner()==c
end
--
function c67200514.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	if ep~=tp and g:GetCount()>0 and g:IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode()) then
	   Duel.NegateEffect(ev)
	end
end



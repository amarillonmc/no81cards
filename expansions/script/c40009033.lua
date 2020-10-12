--机空队 苍天零式
function c40009033.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40009033.matfilter,2)  
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009033,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009033)
	e2:SetCondition(c40009033.thcon)
	e2:SetTarget(c40009033.eqtg)
	e2:SetOperation(c40009033.eqop)
	c:RegisterEffect(e2)  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009033,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,40009034)
	e1:SetTarget(c40009033.target)
	e1:SetOperation(c40009033.activate)
	c:RegisterEffect(e1) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c40009033.target1)
	e3:SetValue(c40009033.indct)
	c:RegisterEffect(e3)   
end
function c40009033.matfilter(c)
	return c:GetBaseAttack()==0 and c:IsType(TYPE_EFFECT)
end
function c40009033.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40009033.eqfilter(c,tp)
	return  (c:IsSetCard(0xf13) and c:IsType(TYPE_QUICKPLAY)) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c40009033.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009033.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40009033.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>=3 then
			g=Duel.SelectMatchingCard(tp,c40009033.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,3,tp)
		else
			g=Duel.SelectMatchingCard(tp,c40009033.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,ft,tp)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,false,true)
		--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(c40009033.eqlimit)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	--local tc=g:GetFirst()
	--while tc do
		--Duel.Equip(tp,tc,c,false,true)
		--local e1=Effect.CreateEffect(c)
		--e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	   -- e1:SetType(EFFECT_TYPE_SINGLE)
	   -- e1:SetCode(EFFECT_EQUIP_LIMIT)
	   -- e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	   -- e1:SetValue(c40009033.eqlimit)
	  --  tc:RegisterEffect(e1)
	  --  tc=g:GetNext()
   -- end
		Duel.EquipComplete()
	end
end
function c40009033.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c40009033.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf13)
end
function c40009033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c40009033.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c40009033.cfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c40009033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c40009033.target1(e,c)
	return c:IsSetCard(0xf13)
end
function c40009033.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end


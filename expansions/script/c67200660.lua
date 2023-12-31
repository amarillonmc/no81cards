--拟态武装 片光零羽
function c67200660.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c67200660.mfilter,c67200660.xyzcheck,2,2)  
	c:EnableReviveLimit() 
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200660,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200660.atkcon1)
	e1:SetTarget(c67200660.atktg1)
	e1:SetOperation(c67200660.atkop1)
	c:RegisterEffect(e1) 
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200660,1))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,67200660)
	e1:SetCost(c67200660.damcost)
	e1:SetTarget(c67200660.damtg)
	e1:SetOperation(c67200660.damop)
	c:RegisterEffect(e1)	
end
--
function c67200660.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(0x667b) 
end
function c67200660.xyzcheck(g)
	return g:GetClassCount(c67200660.getlvrklk)==1
end
function c67200660.getlvrklk(c)
	if c:IsLevelAbove(0) then return c:GetLevel() end
	if c:IsLinkAbove(0) then return c:GetLink() end
	--return c:GetLink()
end
function c67200660.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c67200660.atkval(e,c)
	local g=e:GetHandler():GetMaterial()
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_MONSTER)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*500
end
function c67200660.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) end
end
function c67200660.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c67200660.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
--
function c67200660.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c67200660.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c67200660.sgfilter(c)
	return c:IsSetCard(0x667b) and c:IsLevel(3) 
end
function c67200660.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c67200660.sgfilter,tp,LOCATION_SZONE,0,2,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(67200660,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c67200660.sgfilter,tp,LOCATION_SZONE,0,2,2,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
			local gg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			local sgg=gg:RandomSelect(tp,1)
			Duel.SendtoGrave(sgg,REASON_EFFECT)
		end
	end
end
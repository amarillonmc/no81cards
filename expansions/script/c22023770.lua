--紧握其剑，银之臂
function c22023770.initial_effect(c)
	aux.AddCodeList(c,22021440,22020000,22020200)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22023770.target)
	e1:SetOperation(c22023770.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c22023770.eqlimit)
	c:RegisterEffect(e2)
	--ATTRIBUTE
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetCondition(c22023770.con1)
	e3:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c22023770.con2)
	e4:SetValue(c22023770.efilter)
	c:RegisterEffect(e4)
	--Atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(1800)
	e5:SetCondition(c22023770.con3)
	c:RegisterEffect(e5)
	--to grave
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22023770,0))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,22020050)
	e7:SetTarget(c22023770.tgtg)
	e7:SetOperation(c22023770.tgop)
	c:RegisterEffect(e7)
	if not c22023770.global_flag then
		c22023770.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22023770.regop)
		Duel.RegisterEffect(ge1,0)
		c22023770.global_flag=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(c22023770.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
c22023770.effect_with_altria=true
function c22023770.eqlimit(e,c)
	return c:IsFaceup() and (c:IsSetCard(0xff9) or c:IsCode(22021440) or c.effect_canequip_hogu)
end
function c22023770.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0xff9) or c:IsCode(22021440) or c.effect_canequip_hogu)
end
function c22023770.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22023770.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22023770.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22023770.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22023770.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c22023770.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22020000) then
			Duel.RegisterFlagEffect(tp,22023771,0,0,0)
		elseif tc:IsCode(22020200) then
			Duel.RegisterFlagEffect(tp,22023772,0,0,0)
		elseif tc:IsSetCard(0xff9) then
			Duel.RegisterFlagEffect(tp,22023773,0,0,0)
		end
	end
end
function c22023770.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023771)>0
end
function c22023770.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023772)>0
end
function c22023770.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023773)>0
end
function c22023770.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c22023770.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c22023770.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
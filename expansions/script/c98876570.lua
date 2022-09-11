local m=98876570
local cm=_G["c"..m]
cm.name="狩谷 聚鸦"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.mfilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,98876570)
	e1:SetCost(cm.chcost)
	e1:SetCondition(cm.chcon)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
	--leave1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,98876571)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	--leave2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,98876571)
	e4:SetCondition(cm.ctcon)
	e4:SetTarget(cm.cttg)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
	local e5=Effect.Clone(e4)
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function cm.mfilter(c)
	local x=0
	for _,i in ipairs{c:GetFusionCode()} do
		if i~=c:GetOriginalCodeRule() then x=1 end
	end
	return x==1 or c:GetCode()~=c:GetOriginalCodeRule()
end
function cm.thfilter(c)
	return c:IsType(TYPE_LINK) and c:GetLink()>=1 and c:IsAbleToGraveAsCost()
end
function cm.chfilter(c)
	return ((not c:IsCode(98876570)) or (not c:IsRace(RACE_CYBERSE))) and c:IsFaceup()
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLink())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()
	if ((not x) or x<=0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,x,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsCode(98876570) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(98876570)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if not tc:IsRace(RACE_CYBERSE) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_CYBERSE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(cm.atk1filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atk1filter(c)
	return c:IsSetCard(0x989) and c:IsFaceup()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.atk1filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk*2)
		tc:RegisterEffect(e1)
	end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.ctfilter(c)
	return c:IsSetCard(0x989) and c:IsFaceup() and c:IsControlerCanBeChanged()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local tc=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
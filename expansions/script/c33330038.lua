--大洞穴之城 奥斯镇
local m=33330038
local cm=_G["c"..m]
cm.field={33330019,33330020,33330021,33330022,33330023}
cm.counter=0x1556   --指 示 物
cm.atk=100  --攻 击 力
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--Atk Down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--Indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.indcon)
	e3:SetTarget(cm.indtg)
	e3:SetLabel(1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetLabel(2)
	e4:SetValue(cm.indval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetLabel(3)
	e5:SetValue(cm.indval2)
	c:RegisterEffect(e5)
	--Immune
	local e6=e3:Clone()
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetLabel(4)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
	--Cannot Remove
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_REMOVE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e7:SetCondition(cm.indcon)
	e7:SetTarget(cm.rmtg)
	e7:SetLabel(5)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
--Activate
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
 --Atk Down
function cm.atkval(e,c)
	return -Duel.GetCounter(e:GetHandler(),1,0,cm.counter)*cm.atk
end
--Indes
function cm.indcon(e)
	local i=e:GetLabel()
	return i and Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,cm.field[i])
end
function cm.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x556)
end
function cm.indval1(e,re)
	return aux.indoval(e,re) and re:IsActiveType(TYPE_SPELL)
end
function cm.indval2(e,re)
	return aux.indoval(e,re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_TRAP)
end
--Cannot Remove
function cm.rmtg(e,c)
	return c:IsSetCard(0x556) and c:IsType(TYPE_MONSTER)
end
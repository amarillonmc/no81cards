--断码者 械
if not pcall(function() require("expansions/script/c33337001") end) then require("script/c33337001") end
local m=33337002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)
	rsukv.UnLinkProcedure(c,4,5)   
	c:SetUniqueOnField(1,0,m)
	--ctrl
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler()) end)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e) return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e3)
end
function cm.val(e,c)
	return not c:IsSetCard(0x155b)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() and Duel.GetLocationCount(1-p,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and e:GetHandler():CheckUniqueOnField(1-p) end
	local dis=0
	if p==tp then   
		dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)/0x10000
	else
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	end
	e:SetLabel(dis)
	e:SetValue(p)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetValue()
	if not c:IsRelateToEffect(e) or not c:IsControler(p) then return end
	Duel.GetControl(c,1-p,0,0,e:GetLabel())
end
function cm.cfilter(c)
	return c:IsSetCard(0x155b) and c:IsFaceup()
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x155b)
end
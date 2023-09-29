local m=53753005
local cm=_G["c"..m]
cm.name="脑裂痛觉积压 安吉拉·欧克"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.MultiDual(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.sumcon)
	e1:SetOperation(cm.sumop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(SNNM.DualState)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(SNNM.TerState)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(SNNM.TerState)
	e5:SetValue(cm.indct)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e6:SetCondition(SNNM.QuadState)
	e6:SetValue(cm.immval)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e7:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e7:SetValue(LOCATION_REMOVED)
	e7:SetCondition(SNNM.QuadState)
	e7:SetTarget(cm.rmtg)
	c:RegisterEffect(e7)
end
function cm.cfilter(c)
	return c:IsFaceup() and (SNNM.MultiDualCount(c)>0 or c:IsDualState())
end
function cm.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 and mi<2 then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=SNNM.multi_summon_count(mg)
	return ma>0 and ct>0 and ((ct>=mi and (ft>0 or Duel.CheckTribute(c,1))) or (ct<mi and Duel.CheckTribute(c,mi-ct)))
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local tp=c:GetControler()
	local res=false
	local sg=Group.CreateGroup()
	while mi>0 do
		local mg1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
		local mg2=Group.__sub(Duel.GetTributeGroup(c),sg)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and not sg:IsExists(Card.IsControler,1,nil,tp) then mg2=mg2:Filter(Card.IsControler,nil,tp) end
		local mg=Group.__add(mg1,mg2)
		if res then Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1)) else
			mg=mg1:Clone()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		end
		local mc=mg:Select(tp,1,1,nil):GetFirst()
		local res1=cm.cfilter(mc) and (mi>1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		local res2=res and SNNM.multi_summon_count(Group.__sub(mg,mc))>=mi-1
		res=true
		if res1 and (not res2 or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
			SNNM.multi_summon_count_down(mc)
		else
			sg:AddCard(mc)
		end
		mi=mi-1
	end
	if #sg>0 then
		c:SetMaterial(sg)
		Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	end
end
function cm.val(e,c)
	local val=SNNM.MultiDualCount(c)
	if c:IsDualState() then val=1 end
	return val*300
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function cm.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end

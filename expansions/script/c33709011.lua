--『温柔』的律
local m=33709011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--ins
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(cm.target)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)   
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.atkop)  
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
	if not aux.kemuricheck then
		aux.kemuricheck=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
		e1:SetTarget(cm.tg)
		e1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.tg(e,c)
	local code=c:GetOriginalCode()
	return code>=33709010 and code<=33709015 and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or not (c:IsDisabled() and c:IsLocation(LOCATION_ONFIELD)))
end
function cm.target(e,c)
	return c~=e:GetHandler()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCode()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and code>=33709004 and code<=33709009
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Recover(tp,num*200,REASON_EFFECT)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.check(c)
	local code=c:GetOriginalCode()
	return c:IsDiscardable(REASON_EFFECT) and code>=33709004 and code<=33709009
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_HAND,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
	Duel.RaiseEvent(e:GetHandler(),33709003,re,r,rp,ep,ev)
end
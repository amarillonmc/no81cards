--『决意』的凛
local m=33709010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(cm.ntcon)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)   
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.atkop)  
	c:RegisterEffect(e3)
	--TG
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	--
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
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCode()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and code>=33709004 and code<=33709009
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),0,tp,1000)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(1000)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end
end
function cm.check(c)
	local code=c:GetOriginalCode()
	return code>=33709004 and code<=33709009 and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
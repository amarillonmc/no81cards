local m=82206096
local cm=_G["c"..m]

function c82206096.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e0)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--attribute  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(ATTRIBUTE_DARK)  
	c:RegisterEffect(e2)  
	--reflect damage 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)  
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e3:SetTarget(cm.damtarget)
	e3:SetCost(cm.damcost)  
	e3:SetOperation(cm.damop)  
	c:RegisterEffect(e3) 
	--reflect damage
	local e4=Effect.CreateEffect(c)   
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetCode(EVENT_CHAINING)  
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e4:SetCondition(aux.damcon1)  
	e4:SetTarget(cm.damtarget2)  
	e4:SetCost(cm.damcost) 
	e4:SetOperation(cm.damop2)  
	c:RegisterEffect(e4)  
end

function cm.rfilter(c,tp)  
	return c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,c,ATTRIBUTE_DARK)  
end  

function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2  
		and Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,tp)  
end  

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
	local g1=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,tp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
	local g2=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,g1:GetFirst(),ATTRIBUTE_DARK)  
	g1:Merge(g2)  
	Duel.Release(g1,REASON_COST)  
end  

function cm.damtarget(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local val=Duel.GetBattleDamage(tp)  
	if chk==0 then
		return val>0
	end  
	if Duel.GetLP(tp)<8000 and val>=777 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,8000-Duel.GetLP(tp))
	end
end   

function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReleasable() end  
	Duel.Release(c,REASON_COST)  
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)  
end  

function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("当波拉克斯的光明之力与卡斯托尔的黑暗元素融合至极致，")
	Debug.Message("真正的终末之神将随着天使羽翼的盛放莅临于时之彼端，")
	Debug.Message("届时一切是非对错都将失去意义，")
	Debug.Message("化为神罚之下的齑粉......")
	local c=e:GetHandler()
	local val=Duel.GetBattleDamage(tp) 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)  
	Duel.RegisterEffect(e1,tp)
	Duel.BreakEffect()
	if Duel.GetLP(tp)<8000 and val>=777 then
		Duel.Recover(tp,8000-Duel.GetLP(tp),REASON_EFFECT)
	end
end  

function cm.damtarget2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local ex,tg,tc,targetPlayer,targetParam=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if chk==0 then
		return ex and (targetPlayer==tp or targetPlayer==PLAYER_ALL) and targetParam>0
	end  
	e:SetLabel(targetParam)
	if Duel.GetLP(tp)<8000 and targetParam>=777 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,8000-Duel.GetLP(tp))
	end
end   

function cm.damop2(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("当波拉克斯的光明之力与卡斯托尔的黑暗元素融合至极致，")
	Debug.Message("真正的终末之神将随着天使羽翼的盛放莅临于时之彼端，")
	Debug.Message("届时一切是非对错都将失去意义，")
	Debug.Message("化为神罚之下的齑粉......")
	local label=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)  
	local c=e:GetHandler()
	local targetParam=e:GetLabel()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_REFLECT_DAMAGE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetLabel(label)
	e1:SetValue(cm.v)
	e1:SetReset(RESET_CHAIN)  
	Duel.RegisterEffect(e1,tp)
	Duel.BreakEffect()
	if Duel.GetLP(tp)<8000 and targetParam>=777 then
		Duel.Recover(tp,8000-Duel.GetLP(tp),REASON_EFFECT)
	end
end  

function cm.v(e,re,val,r,rp,rc)  
	local cc=Duel.GetCurrentChain()  
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return false end  
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)  
	return cid==e:GetLabel()
end  
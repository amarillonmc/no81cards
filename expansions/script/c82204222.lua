local m=82204222
local cm=_G["c"..m]
cm.name="堕世魔镜-咒怨"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1) 
	--indes  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_ONFIELD,0)  
	e2:SetCondition(cm.con)  
	e2:SetTarget(cm.indestg)  
	e2:SetValue(1)  
	c:RegisterEffect(e2)
	--set  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(cm.con) 
	e3:SetTarget(cm.settg)  
	e3:SetOperation(cm.setop)  
	c:RegisterEffect(e3) 
end
function cm.indestg(e,c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
end  
function cm.setfilter(c)  
	return c:IsSetCard(0x3298) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()  
end  
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(800)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)  
end  
function cm.setop(e,tp,eg,ep,ev,re,r,rp) 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT)  
end  
 
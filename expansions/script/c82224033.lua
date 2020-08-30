local m=82224033
local cm=_G["c"..m]
cm.name="圣光灵神"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)  
	c:EnableReviveLimit() 
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SPSUMMON_COST)  
	e1:SetCost(cm.spcost)  
	c:RegisterEffect(e1)
	--chair king
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetOperation(cm.sumsuc)  
	c:RegisterEffect(e2)
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	--avoid damage  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)  
	e5:SetValue(1)  
	c:RegisterEffect(e5) 
	--recover and damage 
	local e6=Effect.CreateEffect(c)  
	e6:SetDescription(aux.Stringid(m,0))  
	e6:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)  
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)  
	e6:SetCountLimit(1)  
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCondition(cm.rdcon)  
	e6:SetTarget(cm.rdtg)  
	e6:SetOperation(cm.rdop)  
	c:RegisterEffect(e6)
end
function cm.spcost(e,c,tp,st)  
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end  
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1 
end  
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return end 
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,1)  
	e1:SetValue(cm.aclimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_DISABLE)  
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)  
	e2:SetTarget(cm.disable)  
	e2:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e2,tp)  
end
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsOnField() and e:GetHandler()~=re:GetHandler()  
end  
function cm.disable(e,c)  
	return c~=e:GetHandler() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))  
end  
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetBattledGroupCount()>0  
end  
function cm.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		local ct=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	end
	Duel.SetTargetPlayer(tp) 
	if not ct then return end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)  
end  
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>=Duel.GetLP(1-tp) then return end
	local ct=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	if ct and Duel.Recover(p,ct,REASON_EFFECT)~=0 then   
		Duel.Damage(1-tp,ct,REASON_EFFECT)  
	end  
end
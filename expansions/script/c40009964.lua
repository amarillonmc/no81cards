--最凶兽神 穷奇逆
local m=40009964
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
cm.named_with_Reverse=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end

function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(cm.BeastDeity),8,3,cm.ovfilter,aux.Stringid(m,0),99,cm.xyzop)
	c:EnableReviveLimit()
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge4,0)
	end
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.atkcost)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(cm.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(cm.indcon)
	e5:SetValue(600)
	c:RegisterEffect(e5)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()~=nil and cm.BeastDeity(Duel.GetAttacker()) then
		local pl=Duel.GetAttacker():GetControler()
		if pl then
			cm[pl]=cm[pl]+1
		end
	end
	if Duel.GetAttackTarget()~=nil and cm.BeastDeity(Duel.GetAttackTarget()) then
		local pl=Duel.GetAttackTarget():GetControler()
		if pl then
			cm[pl]=cm[pl]+1
		end
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.ovfilter(c)
	return c:IsFaceup() and cm.BeastDeity(c) and not c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and cm[tp]>0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon() and Duel.GetTurnPlayer()==tp and (e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0)
end
function cm.cfilter(c)
	return cm.BeastDeity(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=c:GetOverlayGroup()
	local g2=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Group.CreateGroup()
	g:Merge(g1)
	g:Merge(g2)
	if chk==0 then return g:GetCount()>1 end
	local g=g:Select(tp,2,2,nil)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if g2:GetCount()>0 then
		Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
	end
	if g2:GetCount()==2 then return false end
	g:Sub(g2)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetFlagEffect(m)==0 then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e2:SetValue(c:GetAttack()*2)
		c:RegisterEffect(e2)
	end
end
function cm.indcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40009966)
end

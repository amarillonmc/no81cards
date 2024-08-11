--希露瓦-永动强音-
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x629,LOCATION_ONFIELD)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter,2,true)
	--summon success
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_COUNTER)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetTarget(cm.tg)
	e11:SetOperation(cm.op)
	c:RegisterEffect(e11)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cgcon)
	e1:SetOperation(cm.cgop)
	c:RegisterEffect(e1)
end
if not cm.cnum then
	cm.cnum=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(cm.cnum)
	local c=e:GetHandler()
	local i=c:GetControler()
	if cm.cnum~=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629) then
		cm.cnum=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,i,i,0)
	end
end
function cm.matfilter(c)
	return c:GetBaseAttack()==0
end
function cm.ctfil(c)
	return c:IsCode(60010143) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x629)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if e:GetHandler():AddCounter(0x629,1)~=0 and Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_FZONE,0,1,nil) then
			local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_FZONE,0,nil)
			if #g==0 then return end
			for c in aux.Next(g) do
				c:AddCounter(0x629,1)
			end
		end
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_MZONE) and not e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end

function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
	local num=Duel.GetOperatedGroup()
	if num~=0 then
		c:AddCounter(0x629,num)
	end
end

function cm.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and (Duel.GetFlagEffect(tp,m)<3 or (Duel.GetFlagEffect(tp,m)<5 and Duel.IsPlayerAffectedByEffect(tp,m+1)))
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m) 
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if #g~=0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
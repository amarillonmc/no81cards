-归墟仲裁 天卫
local m=30015115
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,7,4,2)
	--Effect 1
	local e1=ors.atkordef(c,100,3000)
	--Effect 2  
	local e31=Effect.CreateEffect(c)
	e31:SetDescription(aux.Stringid(m,0))
	e31:SetCategory(CATEGORY_SUMMON)
	e31:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e31:SetCode(EVENT_DAMAGE)
	e31:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e31:SetRange(LOCATION_HAND)
	e31:SetCountLimit(1)
	e31:SetCondition(cm.scon)
	e31:SetTarget(cm.stg)
	e31:SetOperation(cm.sop)
	c:RegisterEffect(e31)
	--Effect 3 
	local e7=ors.monsterle(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015115.isoveruins=true
--Effect 2 
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return  bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31571902,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local b1=c:IsSummonable(true,nil,1) 
	local b2=c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	e1:Reset()
	if chk==0 then return c:GetLocation(LOCATION_HAND) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31571902,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	---
	local rt=0
	if bit.band(r,REASON_BATTLE)~=0 then rt=1 end
	if bit.band(r,REASON_EFFECT)~=0 then rt=2 end
	--limit
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_SUMMON_SUCCESS)
	e01:SetReset(RESET_PHASE+PHASE_END)
	e01:SetOperation(cm.limitop)
	e01:SetLabel(rt,ev)
	Duel.RegisterEffect(e01,tp)
	--reset when negated
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_NEGATED)
	e2:SetOperation(cm.rstop)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.Summon(tp,c,true,nil)
end
----
function cm.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if not tc or tc~=c then return end
	local ty,val=e:GetLabel()
	if ty==1 then
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetCode(EFFECT_UPDATE_ATTACK)
		e01:SetValue(val)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e01)
		Duel.AdjustAll()
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local dg=Group.CreateGroup()
		if #ag==0 then return false end
		for tcc in aux.Next(ag) do  
			local preatk=tcc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tcc:RegisterEffect(e1)
			if preatk~=0 and tcc:IsAttack(0) then dg:AddCard(tcc) end
		end
		if #dg==0 or dg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==0 then return false end
		local dmg=dg:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
		Duel.Remove(dmg,POS_FACEDOWN,REASON_EFFECT)
	end
	if ty==2 then
		Duel.Recover(tp,val*3,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.valp)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	e:Reset()
end
function cm.valp(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return math.floor(dam/2)
	else return dam end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
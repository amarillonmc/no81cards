--虚拟主播 楠栞桜
local m=33701404
local cm=_G["c"..m]
function cm.initial_effect(c)--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(cm.tgcon)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetLabelObject(e2)
	e3:SetCondition(cm.atcon)
	e3:SetOperation(cm.atop)
	c:RegisterEffect(e3)
	
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,1,nil,0x1440,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,nil,0x1440,1)==0 then return end
	local sg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg1=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,0,1,1,nil,0x1440,1)
		local sc=sg1:GetFirst()
		sc:AddCounter(0x1440,1)
		--atk down
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cm.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		sc:RegisterEffect(e1)
		if sc:IsAttackBelow(0) and not sg:IsContains(sc) then
			sg:AddCard(sc)
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function cm.atkval(e,c)
	return c:GetCounter(0x1440)*-1000
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and t~=nil and t:GetAttack()<c:GetAttack() and
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFirstTarget()
	if t:IsRelateToBattle() then
		Duel.SendtoGrave(t,REASON_EFFECT)
	end
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject() and e:GetHandler():IsChainAttackable()
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end

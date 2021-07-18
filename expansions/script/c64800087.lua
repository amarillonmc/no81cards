--尊尼获加
local m=64800087
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.tgtgfil(c,e)
	return c:IsFaceup() and c:IsCanAddCounter(0x1db1,1) and c:IsCanBeEffectTarget(e)
end
function cm.rmfilter(c,e)
	return c:GetCounter(0x1db1)==0
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgtgfil(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgtgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	local gc=Duel.GetMatchingGroupCount(cm.tgtgfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local g=Duel.SelectTarget(tp,cm.tgtgfil,tp,LOCATION_MZONE,LOCATION_MZONE,gc,gc,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,#g,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
		local tc=tg:GetFirst()
		while tc do
			tc:AddCounter(0x1db1,1)
			tc=tg:GetNext()
		end
	local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_RULE)
	end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1db1)>0 end
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1db1)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1db1)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
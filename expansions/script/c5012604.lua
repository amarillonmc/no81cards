--上条当麻
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)

	c:SetUniqueOnField(1,1,id)
	--synchro summon
	--aux.AddSynchroProcedure(c,s.sfliter,aux.TRUE,1)
	aux.AddSynchroProcedure(c,s.sfliter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1131)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(2)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.gspcon)
	e3:SetTarget(s.gsptg)
	e3:SetOperation(s.gspop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(s.gspcon2)
	e4:SetTarget(s.gsptg2)
	c:RegisterEffect(e4)
	--eff
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetCondition(s.effcon)
	e7:SetOperation(s.effop)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(0xff)
	e5:SetValue(s.effectfilter)
	c:RegisterEffect(e5)
end
function s.sfliter(c)
	return (c.MoJin or c:IsSetCard(0x23c))  
end
function s.cfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c==e:GetHandler()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsExists(s.cfilter,1,nil,e)
		and Duel.IsChainDisablable(ev) and not Duel.IsPlayerAffectedByEffect(tp,5012631)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and Duel.IsChainNegatable(ev) and not Duel.IsPlayerAffectedByEffect(tp,5012631)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_DEFENSE) or c:IsFacedown() then return end
	if Duel.ChangePosition(c,POS_FACEUP_DEFENSE) then
		Duel.NegateActivation(ev)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()==nil
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetBattleTarget()~=nil then return end
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	if lp1>lp2 then
		--damage 0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCondition(s.damcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		e2:SetOwnerPlayer(tp)
		c:RegisterEffect(e2)
	elseif lp1<lp2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetCondition(s.condition)
		e1:SetValue(lp2-lp1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	else
		--double
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE)
		e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		c:RegisterEffect(e4)
	end
end
function s.condition(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function s.damcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler()==e:GetHandler() 
end
function s.gtfilter(c,tp)
	return c:IsControler(tp) and (c.MoJin or c:IsSetCard(0x23c))  and c:IsType(TYPE_MONSTER)
		and c:IsLocation(LOCATION_MZONE) and c:IsAbleToHand()
end
function s.gspcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(s.gtfilter,1,nil,tp) and Duel.GetMZoneCount(tp,tg,tp)>0
end
function s.gspcon2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and (c.MoJin or c:IsSetCard(0x23c))   and d:IsControler(tp) 
		and Duel.GetMZoneCount(tp,d,tp)>0 and d:IsAbleToHand()
end
function s.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceupEx()
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(s.gtfilter,nil,tp)
	sg:KeepAlive()
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.gsptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetAttackTarget()
	if chk==0 then return e:GetHandler():IsFaceupEx() and sg:IsAbleToDeck()
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.gstfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsAbleToHand()
end
function s.gspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(s.gstfilter,nil,e)
	
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	if c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsFaceupEx() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	--if Duel.SendtoHand(sg,nil,REASON_EFFECT)==0 then return end
	--if c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsFaceupEx() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,SEQ_DECKTOP,REASON_EFFECT)
end
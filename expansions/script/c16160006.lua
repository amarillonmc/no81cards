--异端的降临者 阿比盖尔
local m=16160006
local cm=_G["c"..m]
function c16160006.initial_effect(c)
	aux.AddCodeList(c,16161000)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,true) 
--------------"Pendulum EFFECT"----------------
	--cannot sendtohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16160006,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c16160006.condition)
	e1:SetCost(c16160006.cscost)
	e1:SetTarget(c16160006.cstarget)
	e1:SetOperation(c16160006.csoperation)
	c:RegisterEffect(e1)
	--FLag for Yog-Sothoth SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(16160006)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
--------------"Monster EFFECT"----------------
	--Removed Card Cannot Effect
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1_1:SetCode(EVENT_CHAINING)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetCondition(c16160006.chcondition)
	e1_1:SetOperation(c16160006.choperation)
	c:RegisterEffect(e1_1)
	--SpecialSummon Yog Token
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(16160001,1))
	e2_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2_1:SetType(EFFECT_TYPE_IGNITION)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCode(EVENT_FREE_CHAIN)
	e2_1:SetCountLimit(1)
	e2_1:SetCost(c16160006.tkcost)
	e2_1:SetTarget(c16160006.tktg)
	e2_1:SetOperation(c16160006.tkop)
	c:RegisterEffect(e2_1)
	--Send to Hand Trigger
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetDescription(aux.Stringid(16160006,1))
	e3_1:SetCategory(CATEGORY_TOHAND)
	e3_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3_1:SetProperty(EFFECT_FLAG_DELAY)
	e3_1:SetCode(EVENT_TO_HAND)
	e3_1:SetCountLimit(1,16160006)
	e3_1:SetCondition(c16160006.spcon)
	e3_1:SetTarget(c16160006.sptg)
	e3_1:SetOperation(c16160006.spop)
	c:RegisterEffect(e3_1)  
end
function c16160006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c16160006.cscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c16160006.cstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c16160006.csoperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
	end
end
function c16160006.condition1(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
-------
function c16160006.chcondition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return false end
	return true
end
function c16160006.choperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	local ce,cp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tf=ce:GetTarget()
	local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ev)
	local tg=g:RandomSelect(tp,1)
	local tc=tg:GetFirst()
	if tf(ce,cp,ceg,cep,cev,cre,cr,crp,0,tc) then
		Duel.ChangeTargetCard(ev,tg)
	else
		e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.ChangeChainOperation(ev,cm.opa)
	end
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c16160006.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c16160006.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonMonster(tp,16160010,nil,0x4011,3500,3500,10,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c16160006.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonMonster(tp,16160010,nil,0x4011,3500,3500,10,RACE_FIEND,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,16160010)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			token:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,2))
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_DESTROYED)
			e2:SetCondition(cm.spcona)
			e2:SetLabelObject(token)
			e2:SetOperation(c16160006.desop)
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EVENT_BATTLE_DESTROYED)
			e3:SetCondition(cm.spcon1)
			e3:SetLabelObject(token)
			Duel.RegisterEffect(e3,tp)
		end
		Duel.SpecialSummonComplete()
		if c:GetFlagEffect(m)==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_DESTROYED)
			e2:SetCondition(cm.spcona)
			e2:SetLabelObject(c)
			e2:SetOperation(c16160006.desop)
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EVENT_BATTLE_DESTROYED)
			e3:SetCondition(cm.spcon1)
			e3:SetLabelObject(c)
			Duel.RegisterEffect(e3,tp)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,2))
		end
	end
end
function cm.cfilter(c,tp,flag,r,ac)
	if not c:IsPreviousControler(1-tp) then return false end
	if flag==1 and r&REASON_EFFECT~=0 then
		local ce=c:GetReasonEffect()
		if ce then
			local rc=ce:GetHandler()
			if rc and aux.GetValueType(rc)=="Card" then
				return rc==ac and rc:IsControler(tp)
			end
		end
	elseif flag==2 then 
		local rc=c:GetReasonCard()
		return rc:IsControler(tp) and rc==ac
	else
		return false
	end
end
function cm.spcona(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() or not e:GetLabelObject():IsLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetFlagEffect(m)==0  then e:Reset() return false end
	local c=e:GetLabelObject()
	return eg:IsExists(cm.cfilter,1,nil,tp,1,r,c)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() or not e:GetLabelObject():IsLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetFlagEffect(m)==0  then e:Reset() return false end
	local c=e:GetLabelObject()
	return eg:IsExists(cm.cfilter,1,nil,tp,2,r,c)
end
function c16160006.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() or not e:GetLabelObject():IsLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetFlagEffect(m)==0  then e:Reset() return end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
----
function c16160006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c16160006.spfilter(c)
	return aux.IsCodeListed(c,16161000) and c:IsAbleToHand()
end
function c16160006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16160006.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16160006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetMatchingGroup(c16160006.spfilter,tp,LOCATION_DECK,0,nil)
	if dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=dg:Select(dg,tp,1,1,nil)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

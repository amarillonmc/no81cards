local m=53734004
local cm=_G["c"..m]
cm.name="执青缀 浅仓奈绪子"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	SNNM.AozoraDisZoneGet(c)
end
function cm.thfilter(c)
	return c:IsSetCard(0x3536) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetTurnPlayer()~=tp and bit.band(Duel.GetCurrentPhase(),PHASE_MAIN2+PHASE_END)==0
	if chk==0 then return SNNM.RinnaZone(tp,Duel.GetMatchingGroup(function(c)return c:GetSequence()<5 and c:IsAbleToRemove()end,tp,LOCATION_MZONE,0,nil))>0 and (b1 or b2) end
	local fdzone=SNNM.RinnaZone(tp,Duel.GetMatchingGroup(function(c)return c:GetSequence()<5 and c:IsAbleToRemove()end,tp,LOCATION_MZONE,0,nil))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local dis=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~fdzone)|0x60)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
	if Duel.GetTurnPlayer()==tp then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	local rc=Duel.GetFieldCard(tp,LOCATION_MZONE,math.log(dis,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c,dis,res=e:GetHandler(),e:GetLabel(),false
	if Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0 and hg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,hg)
			res=true
		end
	else
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BE_BATTLE_TARGET)
		e3:SetOperation(cm.atkop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		res=true
	end
	if res and dis&SNNM.DisMZone(tp)==0 then
		local zone=dis
		if tp==1 then dis=((dis&0xffff)<<16)|((dis>>16)&0xffff) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(dis)
		Duel.RegisterEffect(e1,tp)
		local tc=Duel.GetMatchingGroup(function(c,zone)return (2^c:GetSequence())&zone~=0 end,tp,LOCATION_MZONE,0,nil,zone):GetFirst()
		if not tc then return end
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(LOCATION_REMOVED) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetLabel(zone)
			e2:SetLabelObject(tc)
			e2:SetCondition(cm.retcon)
			e2:SetOperation(cm.retop)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,dis=e:GetLabelObject(),e:GetLabel()
	if not tc or tc:GetFlagEffect(m)==0 then
		e:Reset()
		return false
	else return Duel.CheckLocation(tp,LOCATION_MZONE,math.log(dis,2)) end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc,tc:GetPreviousPosition(),e:GetLabel())
	e:Reset()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d:IsFacedown() or not d:IsSetCard(0x3536) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	e:Reset()
	Duel.Hint(HINT_CARD,0,m)
	if not Duel.NegateAttack() then return end
	local tc=Duel.GetAttacker()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		tc:RegisterEffect(e1)
	end
end

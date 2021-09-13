--自然色彩 三色蜂季香
Duel.LoadScript("c33502100.lua")
local m=33502121
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter,3,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	local e1=Suyuz.fusli_i(c,CATEGORY_SPECIAL_SUMMON,m)
	--HZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.cond)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.hop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.effcon2)
	e3:SetOperation(cm.spsumsuc)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsLevel(9)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
--e2
function cm.cond(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsOnField() and Suyuz.gaincon(m) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()
end
function cm.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tep=re:GetHandlerPlayer()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 end
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,cm.equ)
end
function cm.equ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tep=e:GetHandlerPlayer()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tep,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) then
			c:CancelToGrave(true)
		end
		Duel.Equip(tep,c,tc)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33502121,5))
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		--atk
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(cm.atkvalue)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		--Destroy
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(cm.indvalue)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetCondition(cm.discon)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.atkvalue(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	if ec:IsRace(RACE_PLANT) then
		return 1000
	else
		return -1000
	end
end
function cm.indvalue(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	if ec:IsRace(RACE_PLANT) then
		return 1
	else
		return 0
	end
end
function cm.discon(e)
	local tp=e:GetHandlerPlayer()
	local ec=e:GetHandler():GetEquipTarget()
	return ec:GetRace()~=RACE_PLANT
end
--e3
function cm.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.actvalue)
	e1:SetLabel(Duel.GetCurrentPhase())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.actvalue(e,c)
	if Duel.GetCurrentPhase()==e:GetLabel() then
		return aux.TRUE
	else
		return 0
	end
end
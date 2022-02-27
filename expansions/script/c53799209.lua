local m=53799209
local cm=_G["c"..m]
cm.name="卫衣女 MARU"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.eqcon)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+500)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if not d then return false end
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(a)
	return a:IsControler(tp) and a:IsFaceup() and a:GetControler()~=d:GetControler()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabelObject() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or tc:IsControler(1-tp) or not tc:IsRelateToBattle() then return end
	if not c:CheckUniqueOnField(tp,LOCATION_SZONE) or c:IsForbidden() then return end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(function(e,c)return c==e:GetLabelObject()end)
	c:RegisterEffect(e1)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local etc=e:GetHandler():GetEquipTarget()
	if not etc then return false end
	local bc=etc:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsControler(1-tp) and bc:IsRelateToBattle()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if chk==0 then return bc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc and bc:IsControler(1-tp) and bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) end
	end
end

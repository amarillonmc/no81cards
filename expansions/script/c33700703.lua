--虚毒BOAT
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700703
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.BattleFunction(c,1600)
	rsve.DirectAttackFunction(c,4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)	
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x144b)
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c,tp)
end
function cm.eqfilter(c,tc,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsSetCard(0x144b)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,tp) end
	local ft=0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,tp):GetFirst()
		if ec and Duel.Equip(tp,ec,tc)~=0 then
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		   e1:SetCode(EFFECT_EQUIP_LIMIT)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetValue(cm.eqlimit)
		   ec:RegisterEffect(e1)
		   local e5=Effect.CreateEffect(tc)
		   e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
		   e5:SetCode(EFFECT_DESTROY_REPLACE)
		   e5:SetTarget(cm.reptg)
		   e5:SetOperation(cm.repop)
		   ec:RegisterEffect(e5)
		end
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:GetEquipTarget():IsReason(REASON_BATTLE+REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

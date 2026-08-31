--潮落渊锁『无明业相』
local cm,m=GetID()
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- ①：场上的其他卡不能回到卡组。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(function(e,tc) return tc:IsOnField() and tc~=e:GetHandler() end)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetTargetRange(1,1)
	c:RegisterEffect(e11)
	-- ②：怪兽召唤·特殊召唤的场合才能发动。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
-- =========================================
-- ② 装备系统核心逻辑
-- =========================================
function cm.msfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.eqfilter(c)
	return c:IsSetCard(0x5978) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(cm.msfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or not Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then return false end
		return Duel.GetSZoneCount(tp,Duel.GetFieldGroup(tp,LOCATION_SZONE,0))>0
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.msfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or not Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) or Duel.GetSZoneCount(tp,Duel.GetFieldGroup(tp,LOCATION_SZONE,0))<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqg = Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local eqc = eqg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local msg = Duel.SelectMatchingCard(tp,cm.msfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local msc = msg:GetFirst()
	local unselectable = ~0x1f00
	for i=0,4 do
		local tc = Duel.GetFieldCard(tp,LOCATION_SZONE,i)
		if tc and Duel.GetSZoneCount(tp,tc)==Duel.GetSZoneCount(tp) then
			unselectable = unselectable | (1<<(i+8))
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local fd = Duel.SelectField(tp,1,LOCATION_SZONE,0,unselectable)
	local seq = math.log(fd,2)-8
	local des_c = Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
	local val = 1000
	if des_c then
		Duel.Destroy(des_c,REASON_RULE)
		val = 2000
	end
	if Duel.MoveToField(eqc,tp,tp,LOCATION_SZONE,POS_FACEUP,false,fd>>8) and Duel.Equip(tp,eqc,msc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(msc)
		eqc:RegisterEffect(e1,true)
		local op = Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		local final_val = (op==0) and val or -val
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(final_val)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		eqc:RegisterEffect(e2,true)
		-- 赋予全抗（不受自身以外的效果影响）
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetValue(cm.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		eqc:RegisterEffect(e3,true)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetHandler()
end
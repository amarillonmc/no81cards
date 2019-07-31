--「02退出了观战」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010007
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1})
	local e2=rsef.QO(c,nil,nil,1,"eq",{"tg",EFFECT_FLAG_NO_TURN_RESET },LOCATION_SZONE,nil,nil,rstg.target(rscf.FilterFaceUp(Card.IsCode,65010001),"eq",LOCATION_MZONE),cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetTargetRange(1,1)
		e2:SetValue(cm.aclimit)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetTarget(cm.indtg)
		e3:SetCountLimit(1)
		e3:SetValue(cm.valcon)
		c:RegisterEffect(e3)
	else
		c:CancelToGrave(false)
	end
end
function cm.valcon(e,re,r,rp)
	return r&REASON_EFFECT ~=0
end
function cm.indtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.aclimit(e,re,tp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return false end
	local atk=ec:GetAttack()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsImmuneToEffect(e) and rc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and rc:IsAttackBelow(atk)
end
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsCode(65010001)
end
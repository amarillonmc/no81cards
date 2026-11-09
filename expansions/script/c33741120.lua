--Japari Bun
function c33741120.initial_effect(c)
	--Equip
	aux.AddEquipSpellEffect(c,true,true,c33741120.filter,nil)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33741120.reccon)
	e1:SetOperation(c33741120.recop)
	c:RegisterEffect(e1)
	--destroy sub
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTarget(c33741120.reptg)
	e2:SetOperation(c33741120.repop)
	c:RegisterEffect(e2)
end
function c33741120.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33741120.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc then
		Duel.Hint(HINT_CARD,0,33741120)
		local atk,def=tc:GetBaseAttack(),tc:GetBaseDefense()
		local val=atk>=def and atk or def
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end
function c33741120.filter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33741120.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and not c:GetEquipTarget():IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c33741120.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

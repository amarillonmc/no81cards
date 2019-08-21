--刻刻帝 异界斗争
function c33400118.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33400118.target)
	e1:SetValue(c33400118.indct)
	c:RegisterEffect(e1)
	 --Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,33400118)
	e1:SetCondition(c33400118.descon)
	e1:SetTarget(c33400118.destg)
	e1:SetOperation(c33400118.desop)
	c:RegisterEffect(e1)
end
function c33400118.target(e,c)
	return c:IsSetCard(0x3341)
end
function c33400118.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c33400118.descon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or a:GetControler()==d:GetControler() or not d:IsFaceup() or not a:IsFaceup() then return end
	if a:IsControler(tp) and a:IsSetCard(0x3341) then e:SetLabelObject(d)
	elseif d:IsControler(tp) and d:IsSetCard(0x3341) then e:SetLabelObject(a)
	else return false end
	return true
end
function c33400118.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc:IsOnField() end
	Duel.SetTargetCard(tc)
end
function c33400118.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if  tc:IsControler(1-tp) and Duel.Destroy(tc,REASON_EFFECT)~=1 then
			local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33400118,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g2:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		 
	end
end
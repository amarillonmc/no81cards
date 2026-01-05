--炎狱鬼神 地狱日珥
function c53798006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,Card.IsFaceup,aux.Stringid(53798006,0),2,c53798006.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCondition(c53798006.regcon)
	e1:SetOperation(c53798006.regop)
	c:RegisterEffect(e1)
	--material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c53798006.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
end
function c53798006.xyzop(e,tp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return g:GetCount()>=3 end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c53798006.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():GetSum(Card.GetAttack()))
end
function c53798006.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local c=e:GetHandler()
	if atk>=2000 then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(ct*1000)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if atk<=2000 then
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)-1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(ct*(-500))
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

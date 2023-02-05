--究极宝玉的守护者
function c14469999.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x34),2,true)
	aux.AddContactFusionProcedure(c,aux.TRUE,LOCATION_ONFIELD,0,c14469999.descfop(c))
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c14469999.splimit)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c14469999.indtg)
	e2:SetValue(c14469999.indval)
	c:RegisterEffect(e2)
	--atk double
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14469999,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c14469999.dbcost)
	e3:SetOperation(c14469999.dbop)
	c:RegisterEffect(e3)
end
--Destroy of contact fusion
function c14469999.descfop(c)
	return  function(g)
				Duel.Destroy(g,nil,REASON_COST)
			end
end
function c14469999.splimit(e,se,sp,st)
	return not (e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFacedown())
end
function c14469999.indtg(e,c)
	return c:IsSetCard(0x1034) or (c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x2034))
end
function c14469999.indval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c14469999.dbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c14469999.dbop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,14469999)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e1:SetTarget(c14469999.target)
		e1:SetOperation(c14469999.operation)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,14469999,0,0,1)
	end
end
function c14469999.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a=d end
	if chk==0 then return d and a:IsSetCard(0x34) end
	e:SetLabelObject(a)
end
function c14469999.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
		Duel.ResetFlagEffect(tp,14469999)
		e:Reset()
	end
end

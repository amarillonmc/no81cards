--改良型·悬丝傀儡
local cm,m,o=GetID()
function cm.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,60001542,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.dop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.filter(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0))
end
function cm.con1(e)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandler(),60001542)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local atka,defa=tc:GetAttack(),tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		tc:RegisterEffect(e2)
		local atkb,defb=tc:GetAttack(),tc:GetDefense()
		if (atka~=0 and atkb==0) or (defa~=0 and defb==0) then Duel.Destroy(tc,REASON_EFFECT) end
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function cm.con2(e)
	return Duel.IsPlayerAffectedByEffect(e:GetHandler(),60001542)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			local atka,defa=tc:GetAttack(),tc:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-c:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)  
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(-c:GetDefense())
			tc:RegisterEffect(e2)
			local atkb,defb=tc:GetAttack(),tc:GetDefense()
			if (atka~=0 and atkb==0) or (defa~=0 and defb==0) then Duel.Destroy(tc,REASON_EFFECT) end
			Duel.Destroy(c,REASON_EFFECT)
		end
	else
		Duel.Damage(1-tp,(c:GetAttack()+c:GetDefense())/2,REASON_EFFECT)
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end
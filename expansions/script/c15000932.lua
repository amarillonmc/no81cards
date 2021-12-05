local m=15000932
local cm=_G["c"..m]
cm.name="坠亡死蔷薇-毒藤霍诺利"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000920)
	--Calamity Complainer
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,15000932)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START)
	e2:SetCondition(cm.tk1con)
	c:RegisterEffect(e2)
	--dont
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,15000932)
	e3:SetCost(cm.tgcost)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and not Duel.IsPlayerAffectedByEffect(tp,15000923)
end
function cm.tk1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsPlayerAffectedByEffect(tp,15000923)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,15000920,nil,TYPES_TOKEN_MONSTER,0,3000,12,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000920,nil,TYPES_TOKEN_MONSTER,0,3000,12,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,15000920)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			if token:IsType(TYPE_NORMAL) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_REMOVE_TYPE)
				e1:SetValue(TYPE_NORMAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1,true)
			end
			if not token:IsType(TYPE_EFFECT) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e2,true)
			end
			token:SetUniqueOnField(1,0,15000920)
			--atkup
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(cm.atkval)
			token:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.atkval(e,c)
	local g=Duel.GetFieldGroup(c:GetControler(),LOCATION_GRAVE,0):Filter(Card.IsSetCard,nil,0x3f3f)
	return g:GetSum(Card.GetBaseAttack)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.etarget)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
end
function cm.etarget(e,c)
	return c:IsFaceup() and c:IsCode(15000920)
end
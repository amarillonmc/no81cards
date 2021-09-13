--方舟骑士·重力信使 安洁莉娜
function c82567882.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c82567882.fusionfilter),2,true)
	--add synchro 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	e2:SetCondition(c82567882.actcon)
	c:RegisterEffect(e2)
	--ATK 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(82567882,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82567882)
	e4:SetCost(c82567882.atkcost)
	e4:SetTarget(c82567882.atktg)
	e4:SetOperation(c82567882.atkop)
	c:RegisterEffect(e4)
end
function c82567882.fusionfilter(c)
	return c:IsFusionSetCard(0x825) and c:IsType(TYPE_MONSTER)
end 
function c82567882.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c82567882.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567882.filter(c,e,tp)
	return c:IsFaceup()
end
function c82567882.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567882.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c82567882.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c82567882.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
				  local e2=Effect.CreateEffect(c)
				  e2:SetType(EFFECT_TYPE_SINGLE)
				  e2:SetCode(EFFECT_SET_ATTACK_FINAL)
				  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  e2:SetValue(0)
				  tc:RegisterEffect(e2) 
	 local e6=Effect.CreateEffect(c)
					 e6:SetType(EFFECT_TYPE_SINGLE)
					 e6:SetCode(EFFECT_CANNOT_ATTACK)
					 e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					 c:RegisterEffect(e6)  
  end
end
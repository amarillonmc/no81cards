--假面驾驭·响鬼-装甲形态
function c9980661.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c9980661.ffilter,c9980661.ffilter2,1,true,true)
	aux.AddContactFusionProcedure(c,c9980661.cfilter,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980661.sumsuc)
	c:RegisterEffect(e8)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980661,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9980661.atkcon)
	e1:SetCost(c9980661.atkcost)
	e1:SetOperation(c9980661.atkop)
	c:RegisterEffect(e1)
	--handes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980661,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9980661)
	e4:SetTarget(c9980661.hdtg)
	e4:SetOperation(c9980661.hdop)
	c:RegisterEffect(e4)
end
function c9980661.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980661,1))
end 
function c9980661.ffilter(c)
	return c:IsFusionCode(9980644,9980525) and c:IsType(TYPE_MONSTER)
end
function c9980661.ffilter2(c)
	return c:IsFusionSetCard(0x9bcd,0x3bca) and c:IsType(TYPE_MONSTER)
end
function c9980661.cfilter(c)
	return (c:IsFusionCode(9980644,9980525) or c:IsFusionSetCard(0x9bcd,0x3bca) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost()
end
function c9980661.cfilter2(c)
	return c:IsFusionSetCard(0x9bcd,0x3bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c9980661.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c9980661.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9980661)==0
		and Duel.IsExistingMatchingCard(c9980661.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9980661.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(9980661,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c9980661.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local atk1=g:GetSum(Card.GetRank)*200
		local atk2=g:GetSum(Card.GetLevel)*100
		local atk3=g:GetSum(Card.GetLink)*300
		local atk=atk1+atk2+atk3
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980661,3))
end
function c9980661.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c9980661.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980661,3))
end
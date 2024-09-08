--水剪辑
function c33718014.initial_effect(c)
	
--你控制的「水之女演员 / Aquaactress」怪兽与怪兽战斗的场合，伤害步骤前可以从手牌丢弃1张「水之女演员 / Aquaactress」怪兽；
--那体怪兽的ATK·DEF升高等同于这个效果丢弃的怪兽的ATK·DEF对应数值。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c33718014.condition)
	e1:SetCost(c33718014.cost)
	e1:SetTarget(c33718014.target)
	e1:SetOperation(c33718014.operation)
	c:RegisterEffect(e1)
--这张卡从场上送去墓地的场合，以自己墓地1只水族怪兽为对象才能发动。那只怪兽特殊召唤。
--这个效果的发动后，直到回合结束时自己不是水族怪兽不能特殊召唤。
local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c33718014.spcondition)
	e2:SetTarget(c33718014.sptarget)
	e2:SetOperation(c33718014.spoperation)
	c:RegisterEffect(e2)
end
function c33718014.condition(e)
	local ac=Duel.GetBattleMonster(tp)
	if not (ac and ac:IsFaceup() and ac:IsSetCard(0xcd)) then return false end
	local bc=ac:GetBattleTarget()
	return bc and bc:IsRelateToBattle() and bc:IsControler(1-tp)
end
function c33718014.filter(c)
	return c:IsSetCard(0xcd) and c:IsDiscardable()
end
function c33718014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718014.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c33718014.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	e:SetLabelObject(g)
	Duel.DiscardHand(tp,c33718014.filter,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c33718014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
end
function c33718014.operation(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabelObject():GetAttack()
	local def=e:GetLabelObject():GetDefense()
	local ac=Duel.GetBattleMonster(tp)
	if ac:IsRelateToBattle(e) and ac:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ac:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ac:RegisterEffect(e2)
	end
end

function c33718014.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33718014.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718014.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33718014.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33718014.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33718014.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33718014.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33718014.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33718014.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_AQUA
end

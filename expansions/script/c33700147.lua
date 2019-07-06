--珍稀标本收集处
function c33700147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33700147.splimit)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700147,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c33700147.con)
	e3:SetCost(c33700147.cost)
	e3:SetTarget(c33700147.tg)
	e3:SetOperation(c33700147.op)
	c:RegisterEffect(e3)
end
function c33700147.splimit(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function c33700147.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33700147.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c33700147.cfilter(c,tp)
   local lv 
	if c:GetLevel()>0 then
	lv=c:GetLevel()
elseif c:GetRank()>0 then
	lv=c:GetRank()
end
	return c:IsFaceup() and lv>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33700169,0,0x4011,c:GetAttack(),c:GetDefense(),lv,c:GetRace(),c:GetAttribute())
end
function c33700147.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c33700147.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33700147.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33700147.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33700147.op(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
   local lv 
	if tc:GetLevel()>0 then
	lv=tc:GetLevel()
elseif tc:GetRank()>0 then
	lv=tc:GetRank()
end
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or not e:GetHandler():IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33700169,0,0x4011,tc:GetAttack(),tc:GetDefense(),
			lv,tc:GetRace(),tc:GetAttribute()) then return end
   local token=Duel.CreateToken(tp,33700169)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(lv)
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

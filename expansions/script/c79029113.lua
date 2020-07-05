--汐斯塔·医疗干员-锡兰
function c79029113.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c79029113.condition)
	e1:SetTarget(c79029113.target1)
	e1:SetOperation(c79029113.operation1)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029113.splimit)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,79029030))
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--cannot target
	local e6=e3:Clone()
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--indes
	local e7=e3:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c79029113.lztg)
	e4:SetOperation(c79029113.lzop)
	c:RegisterEffect(e4)  
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(c79029113.lztg1)
	e5:SetOperation(c79029113.lzop1)
	c:RegisterEffect(e5)  
end
function c79029113.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029113.cfilter(c,e,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_PENDULUM)
		and (not e or c:IsRelateToEffect(e))
end
function c79029113.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029113.cfilter,1,nil,nil,tp)
end
function c79029113.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=eg:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,tp,a)
end
function c79029113.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local a=eg:GetCount()   
	 c:AddCounter(0x1099,a)
	end
end
function c79029113.drfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029113.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029113.drfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029113.lzop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029113.drfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	local tc=g:GetFirst()
	local x=tc:GetAttack()
	Duel.Recover(tp,x,REASON_EFFECT)
end
end
function c79029113.lztg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029113.lzop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end













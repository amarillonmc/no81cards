--罗德岛·医疗干员-安塞尔
function c79029141.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c79029141.reptg)
	e1:SetValue(c79029141.repval)
	e1:SetOperation(c79029141.repop)
	c:RegisterEffect(e1)
	 --splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029141.splimit)
	c:RegisterEffect(e2)  
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c79029141.thcon)
	e3:SetTarget(c79029141.thtg)
	e3:SetOperation(c79029141.thop)
	c:RegisterEffect(e3) 
end
function c79029141.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029141.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c79029141.thfilter(c)
	return c:IsSetCard(0x1901) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c79029141.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029141.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029141.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("准备治疗！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029141,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029141.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029141.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0xa900)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79029141.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029141.filter,1,nil,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c79029141.repval(e,c)
	return c79029141.filter(c,e:GetHandlerPlayer())
end
function c79029141.repop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("请坚持住！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029141,1))
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end


























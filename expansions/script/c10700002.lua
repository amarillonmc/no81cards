--漆黑羽翼的骑士 阵风之拉斐尔
function c10700002.initial_effect(c)
	c:EnableCounterPermit(0x10)
	c:SetCounterLimit(0x10,3)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGrave,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10700002.splimit)
	c:RegisterEffect(e1)
	--fusion success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700002,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10700002.addcc)
	e2:SetTarget(c10700002.addct)   
	e2:SetOperation(c10700002.addc)
	c:RegisterEffect(e2)
	--Add COUNTER 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700002,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetCondition(c10700002.countercon)
	e3:SetTarget(c10700002.countertg)
	e3:SetOperation(c10700002.counterop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x33))
	e4:SetValue(c10700002.atkval)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700002,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10700002)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetTarget(c10700002.thtg)
	e5:SetOperation(c10700002.thop)
	c:RegisterEffect(e5)
end
function c10700002.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c10700002.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c10700002.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x10)
end
function c10700002.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x10,2)
	end
end
function c10700002.countercon(e)
	return Duel.GetAttacker():IsSetCard(0x33)
end
function c10700002.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return Duel.GetAttacker():IsSetCard(0x33) end
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x10,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c10700002.counterop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x10,1)
end
function c10700002.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33)
end
function c10700002.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10700002.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c10700002.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700002.thfilter2(c)
	return c:GetCounter(0x10)>0  
end
function c10700002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x10)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c10700002.thfilter1(chkc) and c10700002.thfilter2(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c10700002.thfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700002.thfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.RemoveCounter(tp,1,0,0x10,g:GetCount(),REASON_COST)
end
function c10700002.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
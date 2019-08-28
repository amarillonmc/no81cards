--幻梦迷境 麻奈
function c65010045.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,99,c65010045.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c65010045.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(c65010045.mvtg)
	e3:SetOperation(c65010045.mvop)
	c:RegisterEffect(e3)
	--negate attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCountLimit(1)
	e6:SetCondition(c65010045.condition)
	e6:SetOperation(c65010045.activate)
	c:RegisterEffect(e6)
end
function c65010045.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c65010045.indtg(e,c)
	return c:IsRace(RACE_CYBERSE) and c:IsFaceup() and not c==e:GetHandler()
end
function c65010045.filter(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function c65010045.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65010045.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65010045.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65010045,0))
	Duel.SelectTarget(tp,c65010045.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c65010045.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq) 
end


function c65010045.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttacker()
	return d and d:IsControler(1-tp)
end

function c65010045.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
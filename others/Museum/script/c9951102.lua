--fate·水着玉藻前
function c9951102.initial_effect(c)
	  c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9951102.matfilter,2,2)
 --set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951102,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9951102)
	e1:SetCondition(c9951102.thcon)
	e1:SetTarget(c9951102.settg)
	e1:SetOperation(c9951102.setop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9951102.efilter)
	c:RegisterEffect(e1)
 --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--ATK/DEF gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9951102.atkcon)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951102.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951102.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951102,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951102,1))
end
function c9951102.matfilter(c)
	return c:IsLinkSetCard(0xba5,0x6ba8) and c:IsType(TYPE_NORMAL)
end
function c9951102.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9951102.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9951102.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951102.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9951102.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9951102.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9951102.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c9951102.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP)
end
function c9951102.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951102.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
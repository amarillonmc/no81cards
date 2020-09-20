--物理超度·玄奘三藏
function c9951334.initial_effect(c)
	 c:SetSPSummonOnce(9951334)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),7,2,c9951334.ovfilter,aux.Stringid(9951334,1))
	c:EnableReviveLimit()
 --atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c9951334.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
 --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951334,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c9951334.descost)
	e4:SetTarget(c9951334.destg)
	e4:SetOperation(c9951334.desop)
	c:RegisterEffect(e4)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951334.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951334.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951334,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951334,2))
end
function c9951334.ovfilter(c)
	return c:IsFaceup() and c:IsCode(9951333) 
end
function c9951334.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
function c9951334.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9951334.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c9951334.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9951334.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetDefense()) end
	local g=Duel.GetMatchingGroup(c9951334.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c9951334.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c9951334.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SendtoGrave(g,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951334,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951334,3))
end
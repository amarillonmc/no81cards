--人鱼之魔姬 人鱼姬
function c95101024.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c95101024.uqfilter,LOCATION_MZONE)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c95101024.sprcon)
	e1:SetOperation(c95101024.sprop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c95101024.tgtg)
	e2:SetOperation(c95101024.tgop)
	c:RegisterEffect(e2)
end
function c95101024.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),95101028) then
		return c:IsCode(95101024)
	else
		return c:IsSetCard(0xbba)
	end
end
function c95101024.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:GetCount()>0 and tg:IsExists(Card.IsReleasable,1,nil)
end
function c95101024.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack):Filter(Card.IsReleasable,nil)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tg=tg:Select(tp,1,1,nil)
	end
	Duel.Release(tg,REASON_COST)
end
function c95101024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,3)
end
function c95101024.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g1,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c95101024.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101024.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end

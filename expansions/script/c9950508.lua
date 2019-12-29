--fate·天地惊愕同盟
function c9950508.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9950508.ffilter,2,false)
	 --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9950508.efilter)
	c:RegisterEffect(e3)
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950508,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9950508)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9950508.condition)
	e2:SetTarget(c9950508.target)
	e2:SetOperation(c9950508.operation)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950508.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950508.ffilter(c)
	return c:IsLinkAbove(4) and c:IsSetCard(0xba5)
end
function c9950508.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9950508.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950508,0))
end
function c9950508.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end
function c9950508.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,4)
end
function c9950508.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
		and Duel.SelectYesNo(tp,aux.Stringid(9950508,1)) then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.DiscardDeck(tp,4,REASON_EFFECT)
		Duel.DiscardDeck(1-tp,4,REASON_EFFECT)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950508,0))
end

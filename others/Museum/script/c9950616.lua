--fate·狮子王 阿尔托利亚
function c9950616.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9950616.sprcon)
	e1:SetOperation(c9950616.sprop)
	c:RegisterEffect(e1)
--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c9950616.condition)
	e1:SetTarget(c9950616.target)
	e1:SetOperation(c9950616.activate)
	c:RegisterEffect(e1)
 --change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9950616.chcon1)
	e2:SetOperation(c9950616.chop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950616.chcon2)
	e3:SetOperation(c9950616.chop2)
	c:RegisterEffect(e3)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950616.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950616.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950616,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950616,1))
end
function c9950616.sprfilter(c)
	return c:IsSetCard(0xba5) and c:IsAbleToRemoveAsCost()
end
function c9950616.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950616.sprfilter,tp,LOCATION_GRAVE,0,7,nil)
end
function c9950616.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950616.sprfilter,tp,LOCATION_GRAVE,0,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950616.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE) and not c:IsReason(REASON_DRAW)
end
function c9950616.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9950616.cfilter,1,nil,1-tp)
end
function c9950616.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c9950616.cfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c9950616.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950616,2))
end
function c9950616.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetHandler():GetType()==TYPE_SPELL+TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9950616.chop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(9950616,RESET_CHAIN,0,1)
end
function c9950616.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(9950616)>0
end
function c9950616.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9950616.rep_op)
end
function c9950616.rep_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9950616)
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
end
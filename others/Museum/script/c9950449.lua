--fate·超越凛
function c9950449.initial_effect(c)
	c:SetUniqueOnField(1,0,9950449)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
 --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,9950449)
	e2:SetCondition(c9950449.spcon)
	e2:SetOperation(c9950449.spop)
	c:RegisterEffect(e2)
 --disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950449,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(2,99504490)
	e4:SetCondition(c9950449.discon)
	e4:SetTarget(c9950449.distg)
	e4:SetOperation(c9950449.disop)
	c:RegisterEffect(e4)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950449.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950449.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950449,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950449,1))
end
function c9950449.spfilter(c)
	return c:IsSetCard(0x9ba6) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c9950449.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	local g=Duel.GetMatchingGroup(c9950449.spfilter,tp,LOCATION_HAND,0,c)
	return g:CheckWithSumGreater(Card.GetLevel,12)
end
function c9950449.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9950449.spfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=g:SelectWithSumGreater(tp,Card.GetLevel,12)
	Duel.SendtoGrave(mg,nil,REASON_COST)
end
function c9950449.discon(e,tp,eg,ep,ev,re,r,rp)
	local tgp,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
		and tgp~=tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
end
function c9950449.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9950449.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:GetDefense()<1000 or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	Duel.NegateEffect(ev)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950449,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950449,2))
end

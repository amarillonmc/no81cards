--Anifriends Kuroinari-sama
function c33741101.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon rule
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se1:SetRange(LOCATION_EXTRA)
	se1:SetCondition(c33741101.sprcon)
	se1:SetTarget(c33741101.sprtg)
	se1:SetOperation(c33741101.sprop)
	c:RegisterEffect(se1)
	--Activate Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c33741101.actcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdogcon)
	e2:SetTarget(c33741101.tgtg)
	e2:SetOperation(c33741101.tgop)
	c:RegisterEffect(e2)
end
function c33741101.mfilter(c)
	return (c:IsLevelAbove(1) and c:IsFaceup() or c:IsLocation(LOCATION_DECK) and c:IsCode(33720361)) and c:IsAbleToRemoveAsCost()
end
function c33741101.lvfilter(c,g)
	local tc=g:Filter(aux.TRUE,c):GetFirst()
	return c:GetLevel()-tc:GetLevel()==1
end
function c33741101.fselect(g,tp,sc)
	if Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 or g:GetSum(Card.GetLevel)<11 then return false end
	return g:FilterCount(Card.IsType,nil,TYPE_TUNER)==1 and g:IsExists(c33741101.lvfilter,1,nil,g)
		or aux.gffcheck(g,Card.IsType,TYPE_SYNCHRO,Card.IsCode,33720361) and g:GetSum(Card.GetLevel)==11 and g:FilterCount(Card.IsOnField,nil)==1
end
function c33741101.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c33741101.mfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,nil)
	return g:CheckSubGroup(c33741101.fselect,2,2,tp,c)
end
function c33741101.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c33741101.mfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c33741101.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c33741101.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.Remove(tg,POS_FACEUP,REASON_SPSUMMON)
	tg:DeleteGroup()
end
function c33741101.actcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),0,LOCATION_GRAVE)
	if g:GetClassCount(Card.GetCode)==#g then return false end
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function c33741101.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c33741101.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
end

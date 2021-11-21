local m=31400118
local cm=_G["c"..m]
cm.name="迈向终末的采掘者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.econ)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.econ(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_EFFECT)==0
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local dcount=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if dcount==0 then return end
	local op=Duel.AnnounceType(tp)
	local tgtype
	if op==0 then tgtype=TYPE_MONSTER end
	if op==1 then tgtype=TYPE_SPELL end
	if op==2 then tgtype=TYPE_TRAP end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_DECK,nil,tgtype)
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(1-tp,dcount)
		Duel.ShuffleDeck(1-tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(1-tp,dcount-seq)
	local num=Duel.DiscardDeck(1-tp,dcount-seq,REASON_EFFECT+REASON_REVEAL)
	if num~=0 and Duel.GetFieldGroup(tp,0,LOCATION_GRAVE):FilterCount(Card.IsAbleToRemove,nil,tp)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Remove(Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,num,nil,tp),POS_FACEDOWN,REASON_EFFECT)
	end
end
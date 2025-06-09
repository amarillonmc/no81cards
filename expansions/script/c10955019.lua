--托特塔罗
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,10955019)
	c:EnableReviveLimit()
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	--fusion summon
	aux.AddFusionProcFun2(c,s.ffilter1,s.ffilter2,true)   
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_CHAIN_SOLVING)
	e9:SetCountLimit(2,id)
	e9:SetCondition(s.chcon)
	e9:SetOperation(s.chop)
	c:RegisterEffect(e9)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.ffilter1(c)
	return c.MoJin==true and not c:IsSetCard(0x23c)
end
function s.ffilter2(c)
	return c:IsSetCard(0x23c) and not c.MoJin==true
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local hp=e:GetHandler():GetOwner()
	return (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and Duel.IsExistingMatchingCard(s.dsfilter,hp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsDefensePos()
end
function s.dsfilter(c)
	return c.MoJin==true and c:IsAbleToGrave()
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local hp=e:GetHandler():GetOwner()
	Duel.Hint(HINT_SELECTMSG,hp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(hp,s.dsfilter,hp,0,LOCATION_DECK,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op,loc,seq2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq2>4 then return false end
	local seq1=aux.MZoneSequence(c:GetSequence())
	seq2=aux.MZoneSequence(seq2)
	return bit.band(loc,LOCATION_ONFIELD)~=0
		and (op==1-tp and seq1==4-seq2 or op==tp and seq1==seq2) and e:GetHandler():IsAttackPos()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10955019)
	Duel.NegateEffect(ev)
end
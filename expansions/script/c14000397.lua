--荒碑灵 饿鬼
local m=14000397
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(14000380)
	c:RegisterEffect(e1)
	--set from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.matfilter(c)
	return c:IsLinkCode(14000380)
end
function cm.cfilter(c)
	return cm.Grava(c) and c:IsType(TYPE_FUSION)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.setfilter(c)
	return cm.Grava(c) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
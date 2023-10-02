--君主事件簿 格蕾·礼装解除
local m=77000106
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5ee0),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--selfdes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_SELF_TOGRAVE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.tgcon)
	c:RegisterEffect(e0)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetTarget(cm.rmlimit)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(cm.sumlimit)
	c:RegisterEffect(e3)
	--cannot to hand grave
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_TO_HAND)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetTargetRange(0,1)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_GRAVE))
	c:RegisterEffect(e11)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(m,1))
	e13:SetCategory(CATEGORY_TODECK)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e13:SetProperty(EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_REMOVE)
	e13:SetCondition(cm.thcon)
	e13:SetTarget(cm.thtg)
	e13:SetOperation(cm.thop)
	c:RegisterEffect(e13)
end
	--selfdes
function cm.desfilter3(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function cm.tgcon(e,c)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(cm.desfilter3,tp,LOCATION_ONFIELD,0,1,nil)
end
	--cannot remove
function cm.rmlimit(e,c,p)
	return c:IsLocation(LOCATION_GRAVE)
end
	--spsummon limit
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
	--todeck
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetFlagEffect(m)==0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
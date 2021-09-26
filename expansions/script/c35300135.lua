--龙源圣地 迷雾之城
local m=35300135
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCountLimit(1,m+1)
	e5:SetTarget(cm.atktg1)
	e5:SetOperation(cm.rmop2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e6)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
end
function cm.val(e,re,rp)
	return rp==re:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function cm.fs(c)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsType(TYPE_SYNCHRO)
end
function cm.ste(c)
	return c:IsSetCard(0xac1) or c:IsSetCard(0xac2) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.ste,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.activate(e,tp)
	local g=Duel.GetMatchingGroup(cm.ste,tp,LOCATION_HAND,0,nil)
	if #g<=0 then return end
	local sg=g:Select(tp,1,2,nil)
	Duel.ConfirmCards(1-tp,sg)
	local ct=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	if ct>0 and Duel.IsPlayerCanDraw(tp,ct) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

function cm.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		
	end
end
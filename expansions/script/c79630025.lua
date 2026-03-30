--侦探悠悠
local m=79630025
local set=0x183
local YUU=27288416
local cm=_G["c"..m]
cm.saved={}
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(cm.tunerFilter),aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,YUU,LOCATION_ONFIELD+LOCATION_GRAVE)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.chcon)
	e1:SetTarget(cm.chtg)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
--synchro summon
function cm.tunerFilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--change effect
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function cm.fairynormal(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_NORMAL)
end
function cm.isyuu(c)
	return c:IsCode(set)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	local g=Duel.GetDecktopGroup(tp,5)
	if not g or #g==0 then return end
	Duel.ConfirmCards(PLAYER_ALL,g)
	local cnt_yuu=g:FilterCount(cm.isyuu,nil)
	local has_light_normal=g:IsExists(cm.fairynormal,1,nil)
	if has_light_normal or cnt_yuu>=3 then
		cm.saved[ev]=g
		local tg=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,tg)
		Duel.ChangeChainOperation(ev,cm.repop)
	else
		Duel.ShuffleDeck(tp)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=cm.saved[ev]
	cm.saved[ev]=nil
	if not g or #g==0 then
		Duel.ShuffleDeck(tp)
		return
	end
	if not Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local sg=g:Select(1-tp,1,1,nil)
	if sg and #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end
--tograve
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.tgfilter(c)
	return c:IsSetCard(set) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
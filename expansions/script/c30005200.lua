--闪辉龙 凯旋龙
local m=30005200
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,cm.fs1,cm.fs2,cm.fs3)
	--material limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(cm.matlimit)
	c:RegisterEffect(e0)
	--spsummon condition
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	e01:SetValue(aux.fuslimit)
	c:RegisterEffect(e01)
	--Effect 1
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_NEGATE)
	e02:SetType(EFFECT_TYPE_QUICK_O)
	e02:SetCode(EVENT_CHAINING)
	e02:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCountLimit(1)
	e02:SetCondition(cm.discon)
	e02:SetTarget(cm.distg)
	e02:SetOperation(cm.disop)
	c:RegisterEffect(e02)
	--Effect 2 
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetCategory(CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.descon)
	e12:SetTarget(cm.destg)
	e12:SetOperation(cm.desop)
	c:RegisterEffect(e12)
	--Effect 3 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
--fusion summon
function cm.fs1(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function cm.fs2(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) or c:IsFusionType(TYPE_FUSION)
end
function cm.fs3(c)
	return c:IsFusionType(TYPE_FUSION)
end
function cm.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
--Effect 1
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--Effect 2
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_FUSION) 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Effect 3
function cm.tdfilter(c)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:IsType(TYPE_FUSION) and b1 and c:IsAbleToExtra()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,c)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and #g>0 then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end


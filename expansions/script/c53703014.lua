local m=53703014
local cm=_G["c"..m]
cm.name="抹杀圆盘生物 罗贝拉格"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+0x11e0)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetCountLimit(1)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.sprfilter1(c,tp,syncard)
	local res=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	return c:IsFaceup() and c:IsSetCard(0x3533) and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetOriginalLevel()<=8 and Duel.IsExistingMatchingCard(cm.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,c,syncard) and (res or (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==0 or c:GetSequence()==4 or c:GetSequence()==6 or c:GetSequence()==7)))
end
function cm.sprfilter2(c,tp,tuner,syncard)
	return c:IsFaceup() and c:IsLevel(8) and c:IsSynchroType(TYPE_PENDULUM) and c:IsCanBeSynchroMaterial(syncard,tuner) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(tuner,c),syncard)>0
end
function cm.spcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil,tp,c) and c:IsFacedown()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1,tp,g1:GetFirst(),c)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	c:SetMaterial(g1)
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	c:CompleteProcedure()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetCurrentChain()==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_DECK)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function cm.desfilter(c,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttack())
end
function cm.thfilter(c,atk)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetAttack()>atk and (c:IsAbleToDeck() or (c:IsSetCard(0x3533) and c:IsAbleToHand()))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetAttack()):GetFirst()
		if sc:IsSetCard(0x3533) and sc:IsAbleToHand() and (not sc:IsAbleToDeck() or Duel.SelectOption(tp,1190,aux.Stringid(m,3))==0) then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		else Duel.SendtoDeck(sc,nil,2,REASON_EFFECT) end
	end
end

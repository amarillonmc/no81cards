--圣黑炽天使 加百列
local m=40009893
local cm=_G["c"..m]
cm.named_with_Relief=1
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()   
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)  
end
function cm.efffilter(c)
	return c:IsCode(40009327)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.efffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.efffilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.efffilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local rec=math.abs(8000-Duel.GetLP(tp))
	Duel.SetTargetParam(rec)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec=math.abs(8000-Duel.GetLP(tp))
	local dam=Duel.Recover(tp,rec,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Damage(tp,dam,REASON_EFFECT)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=1000
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=math.floor(ev/1000)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) or c:IsCode(40009909)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=math.floor(ev/1000)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,dg)
	local g=Duel.GetDecktopGroup(tp,dg)
	if g:GetCount()>0 then 
		local ct=g:Filter(cm.tgfilter,nil)
		if ct:GetFirst():IsAbleToGrave() then
			local tc=Duel.SendtoGrave(ct,REASON_EFFECT+REASON_REVEAL)
			if tc==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local bg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,tc,nil)
			if bg:GetCount()==0 then return end
			Duel.BreakEffect()
			Duel.HintSelection(bg)
			Duel.Destroy(bg,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end
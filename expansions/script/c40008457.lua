--时刻利牙虎
local m=40008457
local cm=_G["c"..m]
cm.named_with_Chrono=1
function cm.Chrono(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Chrono
end
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.mfilter,2,63,false)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tdcon)
	e1:SetCost(cm.tdcost)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)  
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(cm.indcon)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)  
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return (cm.Chrono(c) or c:IsSetCard(0x126)) and c:IsType(TYPE_MONSTER)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.costfilter(c)
	return (cm.Chrono(c) or c:IsSetCard(0x126)) and c:IsAbleToRemoveAsCost()
end
function cm.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and (cm.Chrono(c) or c:IsSetCard(0x126)) and not c:IsCode(m)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil,tp)
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,e:GetHandler())
	--if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	local ct=cg:GetCount()
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,ct,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local cs=Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local g2=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK,0,nil,tp)
	if ct==0 then return end
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),ct,cs)
	if ft<=0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	--local sg=g2:Select(tp,1,ft,nil)
	local tg=g2:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if tg then
		local tc=tg:GetFirst()
		while tc do 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			tc=tg:GetNext()
		end
	end
end
function cm.indfilter(c)
	return c:IsFaceup() and cm.Chrono(c)
end
function cm.indcon(e)
	return Duel.IsExistingMatchingCard(cm.indfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local atk=0
	for tc in aux.Next(g) do
		atk=atk+tc:GetOriginalLevel()
	end
	e:SetLabel(atk)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetLabel()*200
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
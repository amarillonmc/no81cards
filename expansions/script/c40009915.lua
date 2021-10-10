--伏魔影密忍军 百鬼风行·那由他
local m=40009915
local cm=_G["c"..m]
cm.named_with_Covertforces=1
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionCode,40009509),2,63,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.matcheck)
	c:RegisterEffect(e2)
end
function cm.Covertforces(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Covertforces
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.matcheck(e,c)
	local ct=c:GetMaterialCount()
	if ct>=3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(ct*700)
		e3:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e3)
		local e1=e3:Clone()
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	if ct>=2 then
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetTarget(cm.destg)
		e2:SetOperation(cm.desop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if ct>=4 then
		--immune
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(cm.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	end
	if ct>=5 then
		--to hand
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(m,1))
		e5:SetCategory(CATEGORY_TOHAND)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCountLimit(1)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCost(cm.thcost)
		e5:SetTarget(cm.thtg)
		e5:SetOperation(cm.thop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.efilter(e,te)
	local tc=te:GetOwner()
	return not cm.Covertforces(tc)
end
function cm.cfilter(c)
	return c:IsCode(m) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and c:IsAbleToExtra() then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
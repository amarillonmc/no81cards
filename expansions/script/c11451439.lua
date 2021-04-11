--波动武士·伽马射线武装
local m=11451439
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--extra remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.ercost)
	e3:SetTarget(cm.ertg)
	e3:SetOperation(cm.erop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.mzfilter(c)
	return c:IsAbleToGraveAsCost() and (c:GetLevel()>=1) and c:IsRace(RACE_PSYCHO)
end
function cm.fselect(g,lv)
	return g:GetSum(Card.GetLevel)==lv and g:GetCount()>=2
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil)
	local lv=7
	while lv<=g:GetSum(Card.GetLevel) do
		local tc=g:CheckSubGroup(cm.fselect,2,#g,lv)
		if tc then return true end
		lv=lv+7
	end
	return false
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil)
	local tp=c:GetControler()
	local list={}
	local lv=7
	while lv<=g:GetSum(Card.GetLevel) do
		local tc=g:CheckSubGroup(cm.fselect,2,#g,lv)
		if tc then table.insert(list,lv) end
		lv=lv+7
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local clv=Duel.AnnounceNumber(tp,table.unpack(list))
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,#g,clv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Card.SetMaterial(c,sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL)
end
function cm.filter4(c,tp)
	return c:IsFacedown() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.ercost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil,POS_FACEDOWN)
	local tg=Duel.GetMatchingGroup(cm.filter4,tp,0,LOCATION_EXTRA,nil,tp)
	local num=math.min(#g,#tg,3)
	if chk==0 then return num>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,num,nil)
	e:SetLabel(Duel.Remove(sg,POS_FACEDOWN,REASON_COST))
end
function cm.ertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,e:GetLabel(),1-tp,LOCATION_EXTRA)
end
function cm.erop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter4,tp,0,LOCATION_EXTRA,nil,tp)
	if g:GetCount()==0 then return end
	local tg=g:RandomSelect(1-tp,e:GetLabel())
	local ct=Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	if ct>0 then
		tg:ForEach(Card.RegisterFlagEffect,m-2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		tg:KeepAlive()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(m,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabelObject(tg)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e2:SetCondition(cm.retcon)
		e2:SetOperation(cm.retop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m-2)~=0
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.filter6,nil,e)
	Duel.SendtoDeck(g,1-tp,0,REASON_EFFECT)
	e:GetLabelObject():DeleteGroup()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #g<10 then return end
	num=math.floor(#g/10)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,num,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,num,num,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	end
end
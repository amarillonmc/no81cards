--时光酒桌 桂月
local m=60002016
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.tgtfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x629) 
end
function cm.extraMove(e,tp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,3)
		local fg=Duel.GetDecktopGroup(tp,3)
		local tg=fg:Filter(cm.tgtfil,nil) 
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
end
--e2
function cm.extra3(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.cnttg)
	e1:SetOperation(cm.cntop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.extra5(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.gcost)
	e2:SetOperation(cm.gop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)  
end
function cm.cnttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function cm.cntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.GetControl(tc,tp,PHASE_END,2)
	timeTable.immue(tc)
end
function cm.ggctfil(c)
	return c:IsSetCard(0x629) and c:IsDiscardable() 
end
function cm.gcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ggctfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.ggctfil,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.gxgcon)
	e1:SetOperation(cm.gxgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(cm.gxspcon)
	e1:SetOperation(cm.gxspop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.gxgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:GetHandler():IsType(TYPE_MONSTER) 
end
function cm.gxgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanDraw(tp,1) then 
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.gxspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>=5 
end
function cm.gxspfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.gxspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.gxspfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetLocationCount(LOCATION_MZONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
	local g=Duel.SelectMatchingCard(tp,cm.gxspfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp) 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
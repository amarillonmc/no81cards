--终墟之始 
local m=30015005
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=ors.atkordef(c,50,1500)
	--Effect 2 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON+CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(3)
	e6:SetCondition(cm.con)
	e6:SetTarget(cm.tg)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--Effect 3 
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(ors.orsmc)
	e21:SetTarget(cm.orsmt)
	e21:SetOperation(cm.orsmp)
	c:RegisterEffect(e21)
end
c30015005.isoveruins=true
--effect 2
function cm.drt(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.sumt(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.drt,tp,LOCATION_REMOVED,0,nil)
	if #mg==0 then return end
	local sg=mg:RandomSelect(tp,1)
	local tcc=sg:GetFirst() 
	if #sg==0 or tcc==nil then return false end  
	if Duel.SendtoHand(tcc,nil,REASON_EFFECT)==0 then return false end
	Duel.ConfirmCards(1-tp,tcc)
	Duel.AdjustAll()
	local sumg=Duel.GetMatchingGroup(cm.sumt,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local setg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,tp,POS_FACEDOWN,REASON_EFFECT)
	local b1=#sumg>0
	local b2=#setg>0
	if #sumg==0 and #setg==0 then return false end
	local op=aux.SelectFromOptions(tp,{b1,1151},{b2,1192})
	if op==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sumc=sumg:Select(tp,1,1,nil):GetFirst()
		ors.sumop(e,tp,sumc)
	else
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rmg=setg:Select(tp,1,1,nil)
		Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)
	end
end
--Effect 3 
function cm.orsmt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_REMOVED)
end
function cm.orsmp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if ct>0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,5))
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,5))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetTargetRange(0,1)
		Duel.RegisterEffect(e1,tp)
	end
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 
	or c:GetLocation()~=LOCATION_HAND then return false end
	local tg=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #tg==0 then return false end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

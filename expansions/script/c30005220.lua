--饲魔的隶姬
local m=30005220
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--Effect 1
	local e10=Effect.CreateEffect(c)  
	e10:SetDescription(aux.Stringid(m,0))
	e10:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,m)
	e10:SetTarget(cm.tg)
	e10:SetOperation(cm.op)
	c:RegisterEffect(e10)   
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e12=e2:Clone()
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	c:RegisterEffect(e12)
	--all
end
--link summon
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_FIEND)
end
--Effect 1
function cm.ff(c)
	local b1=c:IsRace(RACE_FIEND)
	local b2=c:IsType(TYPE_TRAP)
	return c:IsFaceup() and (b1 or b2)
end
function cm.df(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.ft(g)
	return g:IsExists(cm.ff,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.df,tp,LOCATION_REMOVED,0,nil,e)
	if chk==0 then
		return g:CheckSubGroup(cm.ft,3,3)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.ft,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,3,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return end
	local dct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if dct==0 then return false end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,1,nil)
		if #sg==0 then return false end
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(dct*500)
		tc:RegisterEffect(e1)
	end
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
--Effect 2
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsAbleToExtra()
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 and b2 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA)  then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
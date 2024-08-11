--虎克-冒险集结-
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableCounterPermit(0x629,LOCATION_ONFIELD)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1)
	--summon success
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_COUNTER)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetTarget(cm.tg)
	e11:SetOperation(cm.op)
	c:RegisterEffect(e11)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cgcon)
	e1:SetOperation(cm.cgop)
	c:RegisterEffect(e1)

	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.drcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
if not cm.cnum then
	cm.cnum=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(cm.cnum)
	local c=e:GetHandler()
	local i=c:GetControler()
	if cm.cnum~=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629) then
		cm.cnum=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,i,i,0)
	end
end
function cm.mfilter(c)
	return c:GetCounter(0x629)>0
end
function cm.ctfil(c)
	return c:IsCode(60010143) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x629)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if e:GetHandler():AddCounter(0x629,1)~=0 and Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_FZONE,0,1,nil) then
			local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_FZONE,0,nil)
			if #g==0 then return end
			for c in aux.Next(g) do
				c:AddCounter(0x629,1)
			end
		end
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_MZONE) and not e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function cm.filter(c,e,tp)
	return c:IsCanHaveCounter(0x629) and Duel.IsCanAddCounter(tp,0x629,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and c:IsAbleToGrave()
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m) 
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end


function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetTurnCount()~=c:GetTurnID() or c:IsReason(REASON_RETURN)) and Duel.IsPlayerAffectedByEffect(tp,m+1)
end
function cm.drfilter(c,e)
	return c:IsCanHaveCounter(0x629) and Duel.IsCanAddCounter(tp,0x629,1,c) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and g:GetClassCount(Card.GetCode)>4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,5,5)
	aux.GCheckAdditional=nil
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
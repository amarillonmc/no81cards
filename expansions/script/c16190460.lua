--时间的浪客
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16170120)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--抽卡
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)    
end
function s.setfilter(c)
	return aux.IsCodeListed(c,16170120) and not c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,id)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg)
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end        
end        
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(16170120)
end    
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct-1,tp,LOCATION_HAND)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dc=Duel.Draw(p,ct,REASON_EFFECT)-1
	if dc>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local rg=Duel.GetFieldGroup(p,LOCATION_HAND,0):Select(p,dc,dc,nil)
		Duel.ShuffleHand(p)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end
-- 雷霆重塑
local s,id,o=GetID()
function s.initial_effect(c)
local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.activate1)
    c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
    return c:IsSetCard(0xeae9) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) or not e:IsCostChecked())
	local b2=e:GetHandler()
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_COST)
		end
        Duel.SetTargetPlayer(1-tp)
        Duel.SetTargetParam(800)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	elseif op==2 then
         Duel.SetTargetPlayer(1-tp)
		 Duel.SetTargetParam(1000)
		 Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==1 then
		Duel.Damage(p,d,REASON_EFFECT)
	elseif e:GetLabel()==2  then
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nofilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.nofilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
        if #g1>0 then
        Duel.SendtoDeck(g1,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end
function s.nofilter1(c)
	return c:IsSetCard(0xeae9) and c:IsAbleToDeck() and not c:IsCode(36053136)
end

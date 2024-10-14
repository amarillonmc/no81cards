--罗星姬 仙女座
local s,id,o=GetID()
function s.initial_effect(c)
    --Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
    --Draw 1 Card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.drcon)
    e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
    --ToDeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.scon)
	e3:SetTarget(s.stg)
	e3:SetOperation(s.sop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x409) and c:IsFaceup()
        and c:IsPreviousControler(tp) and c:IsPreviousLocation(0x08)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0x04,0,1,e:GetHandler()) end
    Duel.Hint(3,tp,500)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0x04,0,1,1,e:GetHandler()) 
	Duel.Release(g,REASON_COST) 
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.tdfi1ter(c)
	return c:IsSetCard(0x409) and c:IsAbleToDeck() and not c:IsCode(11901440)
        and not (c:IsLocation(0x20) and c:IsFacedown())
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(0x0c)
		and c:IsPreviousPosition(0x5) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfi1ter,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,0x10,nil,1,tp,0x30)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,507)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfi1ter),tp,0x30,0,1,5,nil)
	if g:GetCount()>0 then
        Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,0x40)
	end
end
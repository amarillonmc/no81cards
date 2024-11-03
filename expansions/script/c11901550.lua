--罗星姬 黑洞
local s,id,o=GetID()
function s.initial_effect(c)
    --Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x409),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
    --ToDeck and Draw
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function(e) 
	    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    --Cannot Be Target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0x0c,0)
	e2:SetTarget(s.etlimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
    --Target Destroy
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.cicon)
	e3:SetTarget(s.citg)
	e3:SetOperation(s.ciop)
	c:RegisterEffect(e3)
end
function s.tdfi1ter(c)
	return c:IsSetCard(0x409) and c:IsAbleToDeck()
        and not (c:IsLocation(0x20) and c:IsFacedown())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfi1ter,tp,0x30,0,5,nil)
        and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,0x30)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfi1ter,tp,0x30,0,5,5,nil)
	if #g>0 then
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,0x40)==5 then
            Duel.ShuffleDeck(tp)
		    Duel.Draw(tp,1,0x40)
		end
	end
end
function s.etlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x409) and not c:IsCode(11901550)
end
function s.fi1ter(c)
	return c:IsLocation(0x0c)
end
function s.cicon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        or not re:GetHandler():IsSetCard(0x409) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.fi1ter,1,nil,tp)
end
function s.citg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.fi1ter,nil)
	local tc=tg:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=tg:GetNext()
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,#tg,0,0)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then 
		Duel.Destroy(tg,REASON_EFFECT)
	end 
end
--方舟骑士-灰喉
c29065559.named_with_Arknight=1
function c29065559.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065559+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29065559.hspcon)
	e1:SetOperation(c29065559.hspop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19065559)
	e2:SetTarget(c29065559.drtg)
	e2:SetOperation(c29065559.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065559.summon_effect=e2
end
function c29065559.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST) or Duel.GetFlagEffect(tp,29096814)==1)
end
function c29065559.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_EFFECT)
	end
end
function c29065559.filter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
		and c:IsAbleToDeck()
end
function c29065559.checkfilter(c)
	return c:IsFaceup() and c:IsCode(29065500)
end
function c29065559.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local draw=Duel.IsExistingMatchingCard(c29065559.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065559.filter,tp,LOCATION_GRAVE,0,1,nil)
		and (not draw or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	if draw then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c29065559.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29065559.filter),tp,LOCATION_GRAVE,0,1,3,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(c29065559.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(2857636,1)) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

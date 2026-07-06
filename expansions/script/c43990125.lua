--玩吗？
local m=43990125
local cm=_G["c"..m]
function cm.initial_effect(c)
	--①：召唤·特殊召唤成功时，从卡组送墓1只幻想魔族，检索1张轨道线魔法+1张轨道线怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990125,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--②：被效果送去墓地时，回收2张轨道线卡回卡组，自身特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990125,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,43999125)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
--① filter：幻想魔族怪兽（送墓用）
function cm.gyfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGrave()
end
--① filter：轨道线魔法·怪兽（检索用 合并）
function cm.thfilter(c)
	return c:IsSetCard(0x5510) and c:IsAbleToHand()
		and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_MONSTER))
end
--① SelectSubGroup 校验：1魔法 + 1怪兽
function cm.thsubcheck(g,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
		and g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
--① 嵌套判定：排除候选送墓卡c之后，卡组是否还存在合法检索目标
function cm.thcheck(c,tp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,c)
	return g:CheckSubGroup(cm.thsubcheck,2,2,tp)
end
--① operation用 filter：送墓候选必须通过嵌套判定
function cm.selffilter(c,tp)
	return cm.gyfilter(c) and cm.thcheck(c,tp)
end
--① target
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.gyfilter,tp,LOCATION_DECK,0,nil)
		return g:IsExists(cm.thcheck,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
--① operation
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	--送墓1只幻想魔族（仅展示通过嵌套判定的候选）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.selffilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g1>0 and Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
	--SelectSubGroup 一次选取 1魔法 + 1怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local sg=g:SelectSubGroup(tp,cm.thsubcheck,false,2,2)
	if sg and #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	end
end
--② condition：被效果送去墓地
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
--② filter：这张卡以外的轨道线卡（可回卡组）
function cm.spfilter(c,e)
	return c:IsSetCard(0x5510) and c:IsAbleToDeck() and c~=e
end
--② target
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,c) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--② operation
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,c)
	if #g>0 then Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
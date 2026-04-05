--自我否定森久保
local s,id,o=GetID()
function s.initial_effect(c)
	
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x61d),LOCATION_MZONE)
	
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_GRAVE + LOCATION_REMOVED)
	e2:SetCost(s.cost3)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	e2:SetCountLimit(1, id)
	c:RegisterEffect(e2)
	
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_GRAVE_ACTION + CATEGORY_DRAW + CATEGORY_TODECK + CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e4:SetCost(s.cost2)
	e4:SetTarget(s.target2)
	e4:SetOperation(s.prop2)
	c:RegisterEffect(e4)
	
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 2))
	e5:SetCategory(CATEGORY_DRAW + CATEGORY_POSITION + CATEGORY_TOHAND + CATEGORY_RELEASE)
	
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	
	e5:SetCondition(s.con)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target)
	e5:SetOperation(s.prop)
	--e5:SetCountLimit(1, id)
	c:RegisterEffect(e5)
end


function s.cfilter2(c,tp,e)
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsFaceup() and c:IsControler(tp)  and c:IsReleasable() and c:IsSetCard(0x61d)
end
function s.cost3(e, tp, eg, ep, ev, re, r, rp, chk)
	local g=eg:Filter(s.cfilter2,nil,tp,e)
	if chk==0 then return g:GetCount()>0 end
	Duel.Release(g,REASON_COST)
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x61d) and c:IsControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end

function s.filter(c,tp,e)
	return c:IsSetCard(0x61d) and c:IsAbleToDeck()
end
function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsSetCard(0x61d) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

-- 效果2条件：对方发动场上卡的效果
function s.con(e, tp, eg, ep, ev, re, r, rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (LOCATION_ONFIELD)&loc~=0
		and e:GetHandler():IsFacedown()
end

-- 效果2代价：变成表侧守备表示
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end

-- 效果2目标选择
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingTarget(nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
	local g = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_RELEASE+CATEGORY_TOHAND, g, 1, 0, 0)
end

-- 效果2操作
function s.prop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.ConfirmCards(1 - tp, tc)
		if tc:IsSetCard(0x61d) and Duel.Release(tc,REASON_EFFECT)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

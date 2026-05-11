--落日残响·群愿·Awaken
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6100314,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	
	--①：二速盖放并从卡组解放
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	
	--②：改写效果（只用本家素材时获得）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.tdcon)
	e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e2)
	c:RegisterEffect(e0)
	
	--③：遗言
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.regtg)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(s.thcon2)
	c:RegisterEffect(e4)
end

-- === 效果① ===
function s.setfilter(c,tp)
	if not (c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())) then return false end
	-- 可以盖放 或者 能够表侧表示放置到魔陷区
	return c:IsSSetable() or (not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
end

function s.deckrelfilter(c)
	return c:IsSetCard(0x614) and c:IsAbleToGrave() -- 底层通过发送到墓地+加上RELEASE来模拟
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local b1=tc:IsSSetable()
		local b2=not tc:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		if not (b1 or b2) then return end
		
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
		elseif b1 then
			op=0
		else
			op=1
		end
		
		local res=false
		if op==0 then
			res=Duel.SSet(tp,tc)>0
		else
			res=Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		
		-- 那之后，可以选卡组1张「落日残响」卡解放
		if res then
			local g=Duel.GetMatchingGroup(s.deckrelfilter,tp,LOCATION_DECK,0,nil)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
			end
		end
	end
end

-- === 效果② ===
function s.mfilter(c)
	return not c:IsSetCard(0x614)
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:GetCount()>0 and not mg:IsExists(s.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
-- === 效果② ===
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end

function s.relfilter(c)
	if not (c:IsSetCard(0x614) and c:IsReleasable()) then return false end
	-- 公开的自己手卡，以及自己场上的表侧表示卡
	if c:IsLocation(LOCATION_HAND) then return c:IsPublic() end
	if c:IsLocation(LOCATION_ONFIELD) then return c:IsFaceup() end
	return false
end

function s.tdfilter(c)
	return c:IsAbleToDeck()
end

function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 不能超过对方可洗回卡组的卡片总数
	local max_c=Duel.GetMatchingGroupCount(s.tdfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if chk==0 then return max_c>0 and Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,max_c,nil)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetLabel(ct)
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,e:GetLabel(),1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if #g>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

-- === 效果③ ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 检查因对方从场上离开：战斗破坏 或 对方效果
	if not (c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)) then return false end
	return c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp==1-tp)
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	-- 检查被其他卡解放
	local re_c=nil
	if re then re_c=re:GetHandler() end
	return not re_c or re_c~=e:GetHandler()
end

function s.regfilter(c)
	return c:IsCode(6100314) and c:IsAbleToHand()
end

function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.regfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.regfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
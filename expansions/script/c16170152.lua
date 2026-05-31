local s,id=GetID()

function s.initial_effect(c)
	-- 规则上视为「魔弦」卡
	
	-- ①效果：双方回合除外墓地魔弦卡特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ②效果：特召时或场上其他魔法师族光属性特召时选择效果
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_TOGRAVE)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e2:SetCode(EVENT_SPSUMMON_SUCCESS)
e2:SetRange(LOCATION_MZONE)
e2:SetProperty(EFFECT_FLAG_DELAY)
e2:SetCountLimit(2,id)
e2:SetCondition(s.optcon)
e2:SetTarget(s.opttg)
e2:SetOperation(s.optop)
c:RegisterEffect(e2)
end
-- ②效果条件：自身特召或场上其他魔法师族·光属性特召
function s.optcon(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return false end
	return eg:IsContains(e:GetHandler()) or 
		   (eg:IsExists(aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,nil) and 
			eg:IsExists(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,nil) and 
			eg:IsExists(aux.FilterBoolFunction(Card.IsControler,tp),1,nil))
end
-- ②效果选项筛选
function s.thfilter1(c)
	return  c:IsSetCard(0xb202) and c:IsAbleToHand()
end
function s.thfilter(g)
	return g:IsExists(s.thfilter1,1,nil) 
end
function s.tdfilter(c)
	return c:IsSetCard(0xb202) and c:IsAbleToDeck()
end
function s.exfilter(c)
	return c:IsSetCard(0xb202) and c:IsFaceup() and (c:IsAbleToHand() or  c:IsAbleToDeck())
end
function s.gyfilter(c)
	return c:IsSetCard(0xb202) and c:IsAbleToGrave()
end
function s.rtfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
-- ②效果目标处理
function s.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
	
	local b2=Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_MZONE,0,1,nil)and Duel.GetFlagEffect(tp,id+1)==0
	
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	end
end
-- ②效果操作处理
function s.optop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		-- 选项1：除外区回收
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_REMOVED,0,1,2,nil)
		if #g>0 then
			local tc=g:GetFirst()
			if #g>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:SelectSubGroup(tp,s.thfilter,false,1,1)
				if #sg>0  then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					g:Sub(sg)
					Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				else
					Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
			else
				local tc=g:GetFirst()
				if tc:IsAbleToHand() then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				else
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
			end
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	elseif e:GetLabel()==2 then
		-- 选项2：卡组堆墓+回手
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g1>0 and Duel.SendtoGrave(g1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g2=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if #g2>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
			end
		end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end

-- ①效果：双方回合除外墓地魔弦卡特召
function s.rmfilter(c)
	return c:IsSetCard(0xb202) and c:IsAbleToRemove() and not c:IsCode(id)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
			and #g>=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- ②效果触发条件
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (eg:IsContains(c) and c:IsSummonType(SUMMON_TYPE_SPECIAL)) or
		(eg:IsExists(aux.FilterEqualFunction(Card.IsSummonType,SUMMON_TYPE_SPECIAL),1,nil) and
		 eg:IsExists(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),1,nil) and
		 eg:IsExists(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,nil))
end
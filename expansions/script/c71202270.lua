--天衍四九·飞隼戾焰
local s,id,o=GetID()
function s.initial_effect(c)
	--①: 自己·对方回合1次，这张卡在手卡存在的场合，可以从以下选择1个发动（这个卡名的以下效果1回合各能选择1次，同一连锁上不能发动）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.otg)
	e1:SetOperation(s.oop)
	c:RegisterEffect(e1)
	--②: 从场上送墓的场合
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+200)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

--① 过滤器
function s.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.otg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.lvfilter(chkc) end
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetFlagEffect(tp,id+o)==0 and c:IsAbleToDeck()
		and Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	e:SetCategory(0)
	e:SetProperty(0)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	end
end
function s.oop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if c:IsRelateToEffect(e)
			and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		end
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToEffect(e)
			and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
			and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			-- 以自己场上的怪兽为对象发动的场合，再从对方卡组上面把最多3张卡翻开
			if tc:IsControler(tp) and tc:IsType(TYPE_MONSTER)
				and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
				Duel.BreakEffect()
				local deckct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
				local maxct=math.min(3,deckct)
				local ac=1
				if maxct>1 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
					if maxct==2 then
						ac=Duel.AnnounceNumber(tp,1,2)
					else
						ac=Duel.AnnounceNumber(tp,1,2,3)
					end
				end
				Duel.ConfirmDecktop(1-tp,ac)
				local g=Duel.GetDecktopGroup(1-tp,ac)
				if g:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					Duel.RevealSelectDeckSequence(true)
					local sg=g:FilterSelect(tp,s.rmfilter,1,1,nil,tp)
					Duel.RevealSelectDeckSequence(false)
					if sg:GetCount()>0 then
						Duel.DisableShuffleCheck(true)
						Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
					end
				end
			end
		end
	end
end

--②: 从场上送墓的场合
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c)
	return c:IsSetCard(0x895) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

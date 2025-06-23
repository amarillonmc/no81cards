-- 龗龘速攻魔法
local s,id=GetID()

function s.initial_effect(c)
	-- 速攻魔法特性
	
	-- 效果①：多选效果
	-- 效果②：返回卡组抽卡
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,1))
	e10:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e10:SetCountLimit(1,id+100)
	e10:SetTarget(s.drtg)
	e10:SetOperation(s.drop)
	c:RegisterEffect(e10)
	-- 效果①：丢弃手卡特召墓地/除外的龗龘怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：破坏卡组检索龗龘卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
	-- 效果③：除外卡组处理龗龘卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	
	-- 效果④：解放进行额外召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.extg)
	e4:SetOperation(s.exop)
	c:RegisterEffect(e4)

end
-- ===== 效果① =====

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
-- ===== 效果② =====

function s.thfilter(c)
	return c:IsSetCard(0x5450) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g1>0 and  Duel.SendtoGrave(g1,REASON_EFFECT)>0 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
-- ===== 效果③ =====
function s.rmfilter(c)
	return c:IsSetCard(0x5450) and (c:IsAbleToGrave() or c:IsAbleToRemove() or c:IsReleasable())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			local op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5),aux.Stringid(id,6),aux.Stringid(id,7))
			local tc=g:GetFirst()
			if op==0 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			elseif op==1 then
				Duel.Destroy(tc,REASON_EFFECT)
			elseif op==2 then
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			else
				Duel.Release(tc,REASON_EFFECT)
			end
		end
	end
end
-- ===== 效果④ =====

function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=s.fufilter(e,tp)
	if chk==0 then return (b1 or b2 or b3 or b4) and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x5450)
end
function s.sfilter(c)
	return c:IsSynchroSummonable(nil)and c:IsSetCard(0x5450)
end
function s.lfilter(c)
	return c:IsLinkSummonable(nil)and c:IsSetCard(0x5450)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x5450)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fufilter(e,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
end
-- 效果③操作：进行特殊召唤
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g<1 then return  end
	Duel.Release(g,REASON_EFFECT)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=s.fufilter(e,tp)
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(11185038,3)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(11185038,4)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(11185038,5)
				opval[off-1]=3
				off=off+1
			end
			 if b4 then
				ops[off]=aux.Stringid(11185038,6)
				opval[off-1]=4
				off=off+1
			end  
			local op=Duel.SelectOption(tp,table.unpack(ops)) 
			if opval[op]==1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SynchroSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.XyzSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.LinkSummon(tp,g:GetFirst(),nil)
			else 
				local chkf=tp
				local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e):Filter(Card.IsLocation,nil,LOCATION_MZONE)
				local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
				end
			end
	-- 限制场地魔法发动
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.aclimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end

-- 效果①筛选：特召目标
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果①筛选：检索目标
function s.thfilter(c)
	return c:IsSetCard(0x5450) and c:IsAbleToHand()
end

-- 效果①筛选：卡组操作目标
function s.deckfilter(c)
	return c:IsSetCard(0x5450)
end

-- 效果②目标：返回卡组+抽卡
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end

-- 效果②操作：返回卡组+抽卡
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end

-- 限制场地魔法发动
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and not re:GetHandler():IsSetCard(0x5450)
end

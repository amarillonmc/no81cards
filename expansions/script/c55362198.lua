-- 巨石遗物昇天（抗干扰最终版）
local s,id=GetID()

function s.initial_effect(c)
	-- ①
 local e1=Effect.CreateEffect(c)
 e1:SetDescription(aux.Stringid(id,0))
 e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
 e1:SetType(EFFECT_TYPE_ACTIVATE)
 e1:SetCode(EVENT_FREE_CHAIN)
 e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
 e1:SetCountLimit(1,id)
 e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) -- ⭐关键补充
 e1:SetTarget(s.target)
 e1:SetOperation(s.activate)
 c:RegisterEffect(e1)

	-- ②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

function s.lvfilter(c)
	return c:IsLevelBelow(4)
end

-- ⭐选择分支
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil)
			or Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil)
	end

	local b1=Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil)

	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=0
	else
		op=1
	end

	if op==0 then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	else
		e:SetLabel(2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			e:SetLabelObject(tc)
		end
	end
end

-- ⭐循环选素材（严格不超）
function s.selectritualmat(tp,mg,ritc)
	local mat=Group.CreateGroup()
	local sum=0
	local lv=ritc:GetLevel()

	while true do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,aux.TRUE,1,1,nil)
		local tc=g:GetFirst()
		if not tc then break end

		mat:AddCard(tc)
		mg:RemoveCard(tc)

		sum=sum+tc:GetRitualLevel(ritc)

		if sum>=lv then break end
		if #mg==0 then break end
	end

	if sum>=lv then return mat end
	return nil
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil

	if e:GetLabel()==1 then
		tc=Duel.GetFirstTarget()
	else
		tc=e:GetLabelObject()
		if tc and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
		end
	end

	-- ⭐等级翻倍（绑定在tc自身，不依赖陷阱）
	if tc then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_RITUAL_LEVEL)
		local lv=tc:GetLevel()
		e1:SetValue(function(e,c) return lv*2 end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end

	-- 对方有怪才执行仪式
	if not Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) then return end

	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)

	-- ⭐素材仅场上
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)

	-- ⭐手牌公开怪仍在才加入
	if tc and tc:IsLocation(LOCATION_HAND) then
		mg:AddCard(tc)
	end

	-- ⭐防止无素材直接中断
	if #mg==0 then return end

	-- ⭐选仪式怪（完全独立）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,function(c)
		return c:IsSetCard(0x138) and c:IsType(TYPE_RITUAL)
			and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
	end,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)

	local ritc=g:GetFirst()
	if not ritc then return end

	-- ⭐排除自身（防bug）
	mg:RemoveCard(ritc)

	-- ⭐选素材
	local mat=s.selectritualmat(tp,mg,ritc)

	if mat then
		ritc:SetMaterial(mat)
		Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		if Duel.SpecialSummon(ritc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
			ritc:CompleteProcedure()
		end
	end
end

-- ②
function s.spfilter(c,e,tp,lv,code)
	return c:IsSetCard(0x138) and c:IsType(TYPE_RITUAL)
		and c:IsLevel(lv) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

function s.tgfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	return c:IsFaceup() and c:IsSetCard(0x138) and c:IsType(TYPE_RITUAL)
		and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv,c:GetCode())
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end

	local lv=tc:GetOriginalLevel()
	local code=tc:GetCode()

	if Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,lv,code)
		if #g>0 then
			local sc=g:GetFirst()
			if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end
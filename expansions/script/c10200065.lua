--午夜战栗·尸群围城
function c10200065.initial_effect(c)
	--①：移动并变更表示形式，根据表示形式适用效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200065,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10200065,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10200065.target)
	e1:SetOperation(c10200065.activate)
	c:RegisterEffect(e1)
end
--效果
function c10200065.tgfilter(c,tp)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) then return false end
	if not c:IsCanChangePosition() then return false end
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c10200065.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10200065.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10200065.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10200065.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c10200065.getcolumnseq(c)
	local seq=c:GetSequence()
	local loc=c:GetLocation()
	if loc==LOCATION_MZONE then
		if seq>4 then
			if seq==5 then seq=1
			elseif seq==6 then seq=3 end
		end
	elseif loc==LOCATION_SZONE then
		if seq>4 then return -1 end
	end
	return seq
end
function c10200065.desfilter(c,seqs)
	local cseq=c10200065.getcolumnseq(c)
	if cseq<0 then return false end
	for _,seq in ipairs(seqs) do
		if cseq==seq then return true end
	end
	return false
end
function c10200065.tdfilter(c)
	return c:IsSetCard(0xe25) and c:IsAbleToDeck()
end
function c10200065.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	--移动到相邻区域
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(zone,2)
	Duel.MoveSequence(tc,nseq)
	if tc:GetSequence()~=nseq then return end
	--表示形式变更
	if not tc:IsCanChangePosition() then return end
	if tc:IsAttackPos() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	else
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	end
	--根据表示形式适用效果
	if tc:IsAttackPos() then
		--表侧攻击表示：破坏同纵列及相邻纵列的对方卡
		local curseq=c10200065.getcolumnseq(tc)
		if curseq<0 then return end
		local seqs={curseq}
		if curseq>0 then table.insert(seqs,curseq-1) end
		if curseq<4 then table.insert(seqs,curseq+1) end
		local g=Duel.GetMatchingGroup(c10200065.desfilter,tp,0,LOCATION_ONFIELD,nil,seqs)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	else
		--表侧守备表示：墓地5张午夜战栗卡回卡组，抽2张
		if Duel.IsExistingMatchingCard(c10200065.tdfilter,tp,LOCATION_GRAVE,0,5,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c10200065.tdfilter,tp,LOCATION_GRAVE,0,5,5,nil)
			if #g==5 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==5 then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
end

--午夜战栗·迫近的午夜
function c10200059.initial_effect(c)
	--①：检索午夜战栗怪兽，之后可以移动或表示形式变更
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200059,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10200059,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10200059.thtg)
	e1:SetOperation(c10200059.thop)
	c:RegisterEffect(e1)
	--②：对方召唤时墓地除外，午夜战栗怪兽表示形式变更或里侧守备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200059,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10200059,EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c10200059.poscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10200059.postg)
	e2:SetOperation(c10200059.posop)
	c:RegisterEffect(e2)
end
--①效果
function c10200059.thfilter(c)
	return c:IsSetCard(0xe25) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10200059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200059.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10200059.mvfilter(c,tp)
	if not c:IsFaceup() or not c:IsRace(RACE_ZOMBIE) then return false end
	local seq=c:GetSequence()
	local b1=false
	if seq<=4 then
		b1=(seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
	end
	local b2=c:IsCanChangePosition()
	return b1 or b2
end
function c10200059.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200059.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	--那之后，可以移动或表示形式变更
	if not Duel.IsExistingMatchingCard(c10200059.mvfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(10200059,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectMatchingCard(tp,c10200059.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if #tg==0 then return end
	local tc=tg:GetFirst()
	local seq=tc:GetSequence()
	local b1=false
	local flag=0
	if seq<=4 then
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		b1=flag~=0
	end
	local b2=tc:IsCanChangePosition()
	if not b1 and not b2 then return end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10200059,3),aux.Stringid(10200059,4))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(zone,2)
		Duel.MoveSequence(tc,nseq)
	else
		if tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
	end
end
--②效果
function c10200059.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c10200059.poscfilter(c)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) then return false end
	return c:IsCanChangePosition() or c:IsCanTurnSet()
end
function c10200059.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200059.poscfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10200059.poscfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10200059.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c10200059.poscfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local b1=tc:IsCanChangePosition()
	local b2=tc:IsCanTurnSet()
	if not b1 and not b2 then return end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10200059,4),aux.Stringid(10200059,5))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		if tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
	else
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end

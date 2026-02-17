--午夜战栗·深红舞王
function c10200046.initial_effect(c)
	--①：展示手卡特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200046,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10200046)
	e1:SetCost(c10200046.spcost)
	e1:SetTarget(c10200046.sptg)
	e1:SetOperation(c10200046.spop)
	c:RegisterEffect(e1)
	--②：移动或表示形式变更时破坏对方1张卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200046,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+0xe25)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10200046.descon)
	e2:SetTarget(c10200046.destg)
	e2:SetOperation(c10200046.desop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_CHANGE_POS)
	e2b:SetCondition(c10200046.descon2)
	c:RegisterEffect(e2b)
	--③：对方特殊召唤时移动到相邻区域
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200046,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10200047)
	e3:SetCondition(c10200046.mvcon)
	e3:SetTarget(c10200046.mvtg)
	e3:SetOperation(c10200046.mvop)
	c:RegisterEffect(e3)
end
--①效果
function c10200046.cfilter(c)
	return c:IsSetCard(0xe25) and not c:IsPublic()
end
function c10200046.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic()
		and Duel.IsExistingMatchingCard(c10200046.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10200046.cfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10200046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10200046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--②效果
function c10200046.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c10200046.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and e:GetHandler():IsFaceup()
end
function c10200046.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10200046.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local atk=0
		if tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
			atk=tc:GetBaseAttack()
		end
		if Duel.Destroy(g,REASON_EFFECT)>0 and atk>0 then
			Duel.Damage(1-tp,math.floor(atk/2),REASON_EFFECT)
		end
	end
end
--③效果
function c10200046.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c10200046.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then
		if seq>4 then return false end
		return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
	end
end
function c10200046.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(zone,2)
	Duel.MoveSequence(c,nseq)
end

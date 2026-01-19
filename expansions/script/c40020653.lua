--鸟兽气兵 马面
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+100)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,40020585) then return false end
	
	if rp==tp or c:IsStatus(STATUS_BATTLE_RESULT) then return false end
	
	local n=Duel.GetCurrentChain()
	if n<2 then return false end
	local te,p=Duel.GetChainInfo(n-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	
	return p==tp and s.ForceFighter(te:GetHandler())
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	if Duel.NegateActivation(ev) then

		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.desfilter(c)
	return c:IsFaceup()
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.desfilter(chkc) end
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
		return g:GetCount()>0
	end
	
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=tg:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then

		local b1=true
		local b2=tc:IsAbleToDeck()
		
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		elseif b1 then
			op=0
		elseif b2 then
			op=1
		else
			return
		end
		
		if op==0 then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end

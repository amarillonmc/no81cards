--王之模式
function c1008037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1008037+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c1008037.cost)
	e1:SetTarget(c1008037.target)
	e1:SetOperation(c1008037.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c1008037.thcon)
	e1:SetTarget(c1008037.thtg)
	e1:SetOperation(c1008037.thop)
	c:RegisterEffect(e1)
end
c1008037.DescSetName = 0x320e
local voids ={}
for i = 0,10 do
	voids[i] = 0
end
function c1008037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c1008037.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:GetOriginalLeftScale()>4 and c:IsSetCard(0x320e)
end
function c1008037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1008037.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1008037.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c1008037.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1008037.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(2500)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(1008037,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(0xff)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		tc:RegisterEffect(e1)
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c1008037.sumlimit)
		tc:RegisterEffect(e1)
		local ve1=Effect.CreateEffect(c)
		ve1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ve1:SetCode(EVENT_LEAVE_FIELD)
		ve1:SetRange(LOCATION_MZONE)
		ve1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ve1:SetCondition(c1008037.checkcon)
		ve1:SetOperation(c1008037.checkop)
		tc:RegisterEffect(ve1)
		Duel.SpecialSummonComplete()
	end
end
function c1008037.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x320e)and c:IsLocation(LOCATION_EXTRA)
end
function c1008037.vfilter(c,tp)
	return c:IsSetCard(0x320e) and c:GetCode()~=1008001 and c:IsType(TYPE_MONSTER) and c:GetPreviousLocation()==LOCATION_MZONE -- c:IsControler(tp)
end
function c1008037.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1008037.vfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c1008037.checkop(e,tp,eg,ep,ev,re,r,rp)
	local vg=eg:Filter(c1008037.vfilter,nil,tp)
	local tc=vg:GetFirst()
	local flag=1
	while tc do
		flag=1
		for i=0,10 do
			if voids[i] == tc:GetCode() then 
				flag=0
				break
			end
		end
		if flag==1 then
			voids[e:GetLabel()] = tc:GetCode()
			--gain void
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetDescription(aux.Stringid(voids[e:GetLabel()],1))
			e0:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
			if voids[e:GetLabel()]==1008002 or voids[e:GetLabel()]==1008027 or voids[e:GetLabel()]==1008032
				or voids[e:GetLabel()]==1008007 then
				e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
				e0:SetCategory(CATEGORY_EQUIP)
			end
			e0:SetType(EFFECT_TYPE_IGNITION)
			e0:SetRange(LOCATION_MZONE)
			e0:SetLabel(voids[e:GetLabel()])
			e0:SetCountLimit(1)
			e0:SetTarget(c1008037.voidtg)
			e0:SetOperation(c1008037.voidop)
			e:GetHandler():RegisterEffect(e0)
			e:SetLabel(e:GetLabel()+1)
			-- local e1=Effect.CreateEffect(e:GetHandler())
			-- e1:SetType(EFFECT_TYPE_SINGLE)
			-- e1:SetCode(EFFECT_SET_BASE_ATTACK)
			-- e1:SetValue(e:GetHandler():GetBaseAttack()-300)
			-- e:GetHandler():RegisterEffect(e1)
		end
		tc=vg:GetNext()
	end
	if flag==1 then Duel.Hint(10,0,1008037) end
end

function c1008037.voidfilter(c)
	return c:IsSetCard(0x320e) and c:IsFaceup()
end
function c1008037.voidtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pass=0
	if e:GetCategory()==CATEGORY_EQUIP
		and Duel.IsExistingTarget(c1008037.voidfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		then pass=1
	elseif e:GetLabel()==1008014 then 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,1008016,0x320e,0x4011,0,2500,6,RACE_FAIRY,ATTRIBUTE_LIGHT) then return false end
		pass=1
	elseif e:GetCategory()~=CATEGORY_EQUIP and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		then pass=1
	end
	if chk==0 then return pass==1 and e:GetHandler():IsLocation(LOCATION_MZONE) end
	Duel.Hint(8,tp,e:GetLabel()+2)
	if e:GetCategory()==CATEGORY_EQUIP then
		local g=Duel.SelectTarget(tp,c1008037.voidfilter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c1008037.vtg(e,c)
	local g=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_MZONE,LOCATION_MZONE,nil,1008016)
	if g:GetCount()<2 then return false end
	local maxs=g:GetMaxGroup(Card.GetSequence):GetFirst():GetSequence()
	local mins=g:GetMinGroup(Card.GetSequence):GetFirst():GetSequence()
	return c:GetSequence()>mins and c:GetSequence()<maxs and c:IsFaceup() and c:IsSetCard(0x320e)
end
function c1008037.voidop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code = e:GetLabel()+2
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	if e:GetLabel()==1008014 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or not c:IsRelateToEffect(e) then return end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,1008016,0x320e,0x4011,0,2500,6,RACE_FAIRY,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,1008016)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
			local token2=Duel.CreateToken(tp,1008017)
			Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
			Duel.SpecialSummonComplete()
			--indes
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(c1008037.vtg)
			e1:SetValue(1)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			c:RegisterEffect(e2)
			return
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) then return end
	if e:GetCategory()==CATEGORY_EQUIP then
		local eqc=Duel.GetFirstTarget()
		if eqc:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local g=Group.FromCards(Duel.CreateToken(tp,code))
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.BreakEffect()
			Duel.Equip(tp,tc,eqc,true)
		end
	else
		local g=Group.FromCards(Duel.CreateToken(tp,code))
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c1008037.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c1008037.tfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x320e and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c1008037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1008037.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1008037.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1008037.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

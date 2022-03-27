--陷阵营宠-大黄
function c9330021.initial_effect(c)
	aux.AddCodeList(c,9330001,9330021)
	--synchro /link/xyz limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c9330021.matlimit)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e1)
	local e2=e0:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9330021,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c9330021.discon)
	e3:SetTarget(c9330021.distg)
	e3:SetOperation(c9330021.disop)
	c:RegisterEffect(e3)
	--level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetValue(6)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetTarget(c9330021.rellimit)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9330021,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,9330021)
	e6:SetTarget(c9330021.tdtg)
	e6:SetOperation(c9330021.tdop)
	c:RegisterEffect(e6)
end
function c9330021.matlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xaf93)
end
function c9330021.tfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) 
			and c:IsControler(tp) and c:IsCode(9330001)
end
function c9330021.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c9330021.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c9330021.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9330021.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9330021.rellimit(e,c,tp,sumtp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) 
			and c:IsSetCard(0xaf93) and not c:IsCode(9330021)
end
function c9330021.filter(c)
	return c:IsFacedown() and c:GetSequence()~=5
end
function c9330021.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c9330021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9330021.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,c9330021.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
end
function c9330021.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		if not te then
		   if Duel.IsPlayerCanSpecialSummonMonster(tc:GetControler(),tc:GetCode(),0,0x21,1800,1800,6,RACE_WARRIOR,ATTRIBUTE_EARTH)
			  and tc:IsCanBeSpecialSummoned(e,0,tc:GetControler(),true,true,POS_FACEUP)
			  and Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0
			  and Duel.SelectYesNo(tp,aux.Stringid(9330021,0)) then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
				e1:SetReset(RESET_EVENT+0x47c0000)
				tc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(RACE_WARRIOR)
				tc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetValue(ATTRIBUTE_EARTH)
				tc:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(1800)
				tc:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(1800)
				tc:RegisterEffect(e5,true)
				local e6=e1:Clone()
				e6:SetCode(EFFECT_CHANGE_LEVEL)
				e6:SetValue(6)
				tc:RegisterEffect(e6,true)
				Duel.SpecialSummon(tc,0,tp,tc:GetControler(),true,false,POS_FACEUP)
			else
			end
		else
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if te:GetCode()==EVENT_FREE_CHAIN 
				and te:IsActivatable(tep)
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				Duel.ChangePosition(tc,POS_FACEUP)
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local tg=g:GetFirst()
				while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
				end
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				tg=g:GetFirst()
				while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
				end
			else
				if Duel.IsPlayerCanSpecialSummonMonster(tc:GetControler(),tc:GetCode(),0,0x21,1800,1800,6,RACE_WARRIOR,ATTRIBUTE_EARTH)
				and tc:IsCanBeSpecialSummoned(e,0,tc:GetControler(),true,true,POS_FACEUP)
				and Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9330021,0)) then
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
					e1:SetReset(RESET_EVENT+0x47c0000)
					tc:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_CHANGE_RACE)
					e2:SetValue(RACE_WARRIOR)
					tc:RegisterEffect(e2,true)
					local e3=e1:Clone()
					e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
					e3:SetValue(ATTRIBUTE_EARTH)
					tc:RegisterEffect(e3,true)
					local e4=e1:Clone()
					e4:SetCode(EFFECT_SET_BASE_ATTACK)
					e4:SetValue(1800)
					tc:RegisterEffect(e4,true)
					local e5=e1:Clone()
					e5:SetCode(EFFECT_SET_BASE_DEFENSE)
					e5:SetValue(1800)
					tc:RegisterEffect(e5,true)
					local e6=e1:Clone()
					e6:SetCode(EFFECT_CHANGE_LEVEL)
					e6:SetValue(6)
					tc:RegisterEffect(e6,true)
					Duel.SpecialSummon(tc,0,tp,tc:GetControler(),true,false,POS_FACEUP)
				else
				end
			end
		end
	end
end
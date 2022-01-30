fufu_loop=fufu_loop or {}

--loop.continu spell:create token and destroy token
function fufu_loop.ctadt(c)
	local tc=c
--creat token
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local seq=e:GetHandler():GetSequence()
		if chk==0 then return true end
		e:SetLabel(seq)
		if seq==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
			Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local label=e:GetLabel()
		if label==0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and Duel.IsPlayerCanSpecialSummonMonster(tp,20000200,nil,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PSYCHO,ATTRIBUTE_LIGHT) then
				local token=Duel.CreateToken(tp,20000200)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
				e:GetHandler():SetCardTarget(token)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(1)
				token:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end)
	tc:RegisterEffect(e1)
--destroy token
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsDisabled() then
			e:SetLabel(1)
		else e:SetLabel(0) end
	end)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetLabelObject():GetLabel()~=0 then return end
		local ftc=e:GetHandler():GetFirstCardTarget()
		if ftc and ftc:IsLocation(LOCATION_MZONE) then
			Duel.Destroy(ftc,REASON_EFFECT)
		end
	end)
	e3:SetLabelObject(e2)
	tc:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local ftc=e:GetHandler():GetFirstCardTarget()
		return ftc and eg:IsContains(ftc)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end)
	tc:RegisterEffect(e4)
	return e1
end
--loop.continu spell:buff
function fufu_loop.b(c,cod,val)
	local tc=c
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(cod)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,20000200))
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local seq=c:GetSequence()
		return seq~=0 and seq<5
	end)
	e5:SetValue(val)
	tc:RegisterEffect(e5)
	return e5
end
--loop.spell:search
function fufu_loop.s(c)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(function(c)
			return c:IsFaceup() and c:IsCode(20000200)
		end,tp,LOCATION_MZONE,0,1,nil)
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsDiscardable() end
		Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(function(c)
			return aux.IsCodeListed(c,20000200) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
		end,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,function(c)
			return aux.IsCodeListed(c,20000200) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
		end,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	tc:RegisterEffect(e1)
	return e1
end
--loop.spell:return
function fufu_loop.ro(c,cat,cod,op)
	local tc=c
	local e2=Effect.CreateEffect(c)
	if cat then
		e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+cat)
	else
		e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	end
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,cod)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(function(c)
			return c:IsFaceup() and c:IsCode(20000200) end,tp,LOCATION_MZONE,0,1,nil)
	end)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_SZONE,0,1,nil) end
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_SZONE)>-1 and Duel.IsExistingMatchingCard(function(c,tp)
			return c:GetType()==0x20002 end,tp,LOCATION_HAND,0,1,nil,tp) end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,20000200,nil,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PSYCHO,ATTRIBUTE_LIGHT) then return end
			local token=Duel.CreateToken(tp,20000200)
			if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)==0 then return end
			local g=Duel.SelectMatchingCard(tp,function(c,tp)
				return c:GetType()==0x20002 and c:GetActivateEffect():IsActivatable(tp,true,true) end,tp,LOCATION_HAND,0,1,1,nil,tp)
			local tc=g:GetFirst()
			if tc:GetActivateEffect():IsActivatable(tp,true,true) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				te:UseCountLimit(tp,1,true)
				local cost=te:GetCost()
				if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
			end
		end
	end)
	tc:RegisterEffect(e2)
	return e2
end
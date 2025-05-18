--向着不可追问处
function c60158210.initial_effect(c)
	aux.AddCodeList(c,60158001)

	--场地发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--免疫
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c60158210.e1valf)
	e1:SetCondition(c60158210.e1con)
	c:RegisterEffect(e1)
	
	--改卡名
	aux.EnableChangeCode(c,60158001,LOCATION_FZONE,c60158210.e1con)
	
	--攻击力上升【解读】层数
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e2:SetCode(EFFECT_UPDATE_ATTACK)
	--e2:SetRange(LOCATION_FZONE)
	--e2:SetTargetRange(LOCATION_MZONE,0)
	--e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,60158001))
	--e2:SetValue(c60158210.e2val)
	--e2:SetCondition(c60158210.e1con)
	--c:RegisterEffect(e2)
	
	--赋予①效果二速
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(60158210)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,60158001))
	e3:SetCondition(c60158210.e1con)
	c:RegisterEffect(e3)
	
	--2xg
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60158210,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,60158210)
	e4:SetCondition(c60158210.e4con)
	e4:SetCost(c60158210.e4cost)
	e4:SetTarget(c60158210.e4tg)
	e4:SetOperation(c60158210.e4op)
	c:RegisterEffect(e4)
end

	--免疫
function c60158210.e1valf(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c60158210.e1conf(c)
	return c:IsCode(60158001) and c:IsFaceup()
end
function c60158210.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60158210.e1conf,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

	--攻击力上升【解读】层数
function c60158210.e2val(e,c)
	local tp=e:GetHandlerPlayer()
	local atk=Duel.GetFlagEffect(1-tp,60158210)
	return atk*400
end

	--2xg
function c60158210.e4con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60158210.e4costf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) 
		and ((c:IsAbleToGraveAsCost() and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or c:IsLocation(LOCATION_HAND))) 
			or (c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)))
end
function c60158210.e4cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158210.e4costf,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158210,4))
	local g=Duel.SelectMatchingCard(tp,c60158210.e4costf,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_ONFIELD+LOCATION_HAND) then
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
end
function c60158210.e4tgf(c)
	return aux.IsCodeListed(c,60158001) and not c:IsCode(60158210) and (c:IsSSetable() or not c:IsForbidden())
		and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60158210.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c60158210.e4tgf,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158210,3))
end
function c60158210.e4op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158210,7))
	local g=Duel.SelectMatchingCard(tp,c60158210.e4tgf,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local sc=g:GetFirst()
		if sc:IsSSetable() and not sc:IsForbidden() then 
			if Duel.SelectYesNo(tp,aux.Stringid(60158210,5)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				if sc:IsType(TYPE_FIELD) then
					Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				else
					Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			else
				Duel.SSet(tp,sc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(60158210,6))
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				sc:RegisterEffect(e2)
			end
		elseif sc:IsSSetable() and sc:IsForbidden() then
			Duel.SSet(tp,sc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(60158210,6))
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			sc:RegisterEffect(e2)
		elseif not sc:IsSSetable() and not sc:IsForbidden() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			if sc:IsType(TYPE_FIELD) then
				Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		else
			return false
		end
	end
end
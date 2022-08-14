local m=10419909
local cm=_G["c"..m]
cm.named_with_Kabal=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and Duel.GetTurnCount()>=4
end
function cm.thfilter(c)
	return cm.Potion(c) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local tc=g:GetFirst()
		--Public
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,9))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local sel=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,7))+1
		if sel==1 then
			tc:RegisterFlagEffect(10419701,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
			--Public
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,3))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local sel=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			sel=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,7))+1
			if sel==1 then
				tc:RegisterFlagEffect(10419702,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,4))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==2 then
				tc:RegisterFlagEffect(10419703,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,5))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==3 then
				tc:RegisterFlagEffect(10419704,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,6))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==4 then
				tc:RegisterFlagEffect(10419705,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,7))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		elseif sel==2 then
			tc:RegisterFlagEffect(10419702,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
			--Public
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,4))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local sel=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,7))+1
			if sel==1 then
				tc:RegisterFlagEffect(10419701,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,3))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==2 then
				tc:RegisterFlagEffect(10419703,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,5))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==3 then
				tc:RegisterFlagEffect(10419704,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,6))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==4 then
				tc:RegisterFlagEffect(10419705,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,7))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		elseif sel==3 then
			tc:RegisterFlagEffect(10419703,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
			--Public
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,5))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local sel=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,6),aux.Stringid(m,7))+1
			if sel==1 then
				tc:RegisterFlagEffect(10419701,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,3))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==2 then
				tc:RegisterFlagEffect(10419702,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,4))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==3 then
				tc:RegisterFlagEffect(10419704,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,6))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==4 then
				tc:RegisterFlagEffect(10419705,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,7))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		elseif sel==4 then
			tc:RegisterFlagEffect(10419704,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
			--Public
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,6))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local sel=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,7))+1
			if sel==1 then
				tc:RegisterFlagEffect(10419701,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,3))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==2 then
				tc:RegisterFlagEffect(10419702,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,4))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==3 then
				tc:RegisterFlagEffect(10419703,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,5))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==4 then
				tc:RegisterFlagEffect(10419705,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,7))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		elseif sel==5 then
			tc:RegisterFlagEffect(10419705,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
			--Public
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,7))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local sel=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6))+1
			if sel==1 then
				tc:RegisterFlagEffect(10419701,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,3))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==2 then
				tc:RegisterFlagEffect(10419702,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,4))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==3 then
				tc:RegisterFlagEffect(10419703,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,5))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			elseif sel==4 then
				tc:RegisterFlagEffect(10419704,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				--Public
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(m,6))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_PUBLIC)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(m) 
end


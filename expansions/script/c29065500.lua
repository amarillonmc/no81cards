--方舟骑士-阿米娅
c29065500.named_with_Arknight=1
function c29065500.initial_effect(c)
	--summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(29065500,0))
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetCondition(c29065500.ntcon)
	c:RegisterEffect(e7)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065500,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29065500)
	e1:SetTarget(c29065500.thtg)
	e1:SetOperation(c29065500.thop)
	c:RegisterEffect(e1)	
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065500.summon_effect=e1   
end
--summon with no tribute
function c29065500.cfilter(c)
	return not c:IsSetCard(0x87af) and c:IsType(TYPE_EFFECT)
end
function c29065500.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c29065500.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29065500.thandcon(e)
	local c=e:GetHandler()
	return e:GetHandler():IsAbleToHand() and e:GetHandler():GetFlagEffect(29065500)>0
end
function c29065500.thandop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c29065500.thandcon2(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c29065500.thandop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(29065500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c29065500.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c29065500.thfilter1(c)
	return c:IsSetCard(0x87af) and c:IsAbleToHand()
end
function c29065500.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065500.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065500.actfilter(c,tp)
	return c:IsCode(29065510) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c29065500.bsfilter(c)
	return c:IsCode(29065502) and c:IsFaceup()
end
function c29065500.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065500.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c29065500.actfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(c29065500.bsfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29065500,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c29065500.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		end
	end
end
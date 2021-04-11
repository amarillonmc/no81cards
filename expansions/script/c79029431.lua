--企鹅战法·月隐晦明
function c79029431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c79029431.cost)
	e1:SetTarget(c79029431.target)
	e1:SetOperation(c79029431.operation)
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029431)
	e2:SetCost(c79029431.thcost)
	e2:SetTarget(c79029431.thtg)
	e2:SetOperation(c79029431.thop)
	c:RegisterEffect(e2)
end
function c79029431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil,POS_FACEDOWN)==1 end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029431.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c79029431.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler()):GetFirst()
	if tc:GetOverlayCount()~=0 then
	Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE)
	end   
	if Duel.Exile(tc,REASON_EFFECT) then
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	if tc:IsPreviousLocation(LOCATION_PZONE) then
	e1:SetLabel(1)
	elseif tc:IsPreviousLocation(LOCATION_FZONE) then
	e1:SetLabel(2)
	else
	e1:SetLabel(0)
	end
	e1:SetLabelObject(tc)
	e1:SetOperation(c79029431.rtop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Debug.Message("那就赶紧了结了吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,0))   
	end
end
function c79029431.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local loc=0
	if e:GetLabel()==1 then
	loc=LOCATION_PZONE 
	elseif e:GetLabel()==2 then 
	loc=LOCATION_FZONE  
	else
	loc=tc:GetPreviousLocation()
	end
	if tc:GetOriginalCode()==79029384 and Duel.GetFlagEffect(tp,09029431)~=0 then
	Duel.Hint(HINT_CARD,0,79029384)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,4))  
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,10)) 
	Duel.Hint(HINT_CARD,0,79029382)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,11)) 
	Duel.Hint(HINT_CARD,0,79029384)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,12)) 
	Duel.Hint(HINT_CARD,0,79029383)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,13)) 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,3))  
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,14)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,15)) 
	Duel.RegisterFlagEffect(tp,09029431,0,0,0)  
	elseif tc:GetOriginalCode()==79029382 and Duel.GetFlagEffect(tp,19029431)~=0 then 
	Duel.Hint(HINT_CARD,0,79029382)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,5)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,7))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,8))
	Duel.Hint(HINT_CARD,0,79029383)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,2)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029431,9)) 
	Duel.RegisterFlagEffect(tp,19029431,0,0,0)   
	else
	Debug.Message("我对你们还算是有感情的。大多数时候。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,1))
	end   
	e:Reset()
	Duel.MoveToField(tc,tp,tc:GetPreviousControler(),loc,tc:GetPreviousPosition(),true)
end
function c79029431.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029431.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c79029431.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsRelateToEffect(e) then 
	Debug.Message("可别耽误我太长时间。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029431,6))  
	Duel.SSet(tp,e:GetHandler())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	end
end


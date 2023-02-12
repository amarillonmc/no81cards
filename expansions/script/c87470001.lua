--时刻爱丽丝
function c87470001.initial_effect(c)
	c:EnableReviveLimit()  
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,87470001+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c87470001.xtdcon) 
	e1:SetTarget(c87470001.xtdtg)
	e1:SetOperation(c87470001.xtdop)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DRAW)
	e2:SetCountLimit(1,17470001+EFFECT_COUNT_CODE_DUEL) 
	e2:SetCost(c87470001.spcost)
	e2:SetTarget(c87470001.sptg)
	e2:SetOperation(c87470001.spop)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_TO_DECK) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTarget(c87470001.atktg) 
	e3:SetOperation(c87470001.atkop) 
	c:RegisterEffect(e3)
end
function c87470001.xtdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_MZONE+LOCATION_HAND)
end 
function c87470001.xtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and re:GetHandler():IsAbleToDeck() end 
	local g=Group.FromCards(e:GetHandler(),re:GetHandler()) 
	Duel.SetTargetCard(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c87470001.xtdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then  
	local cg=Group.FromCards(c,tc) 
	cg:KeepAlive() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAIN_END) 
	e1:SetLabel(c:GetFieldID(),tc:GetFieldID())
	e1:SetLabelObject(tc) 
	e1:SetCondition(c87470001.tdcon) 
	e1:SetOperation(c87470001.tdop) 
	Duel.RegisterEffect(e1,tp)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1) 
	e2:SetLabel(tc:GetCode())
	e2:SetTarget(c87470001.dsrtg) 
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,12)
	Duel.RegisterEffect(e2,tp) 
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DRAW) 
	e3:SetLabel(0,tc:GetCode(),Duel.GetTurnCount())
	e3:SetOperation(c87470001.xckop)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,12)
	Duel.RegisterEffect(e3,tp) 
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c87470001.turncon)
	e4:SetOperation(c87470001.turnop)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,12)
	Duel.RegisterEffect(e4,tp)
	e4:SetLabelObject(e3)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,12)
	c87470001[e:GetHandler()]=e4 
	end 
end 
function c87470001.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	return true 
end 
function c87470001.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	local cg=Group.CreateGroup()
	if lab1==c:GetFieldID() then cg:AddCard(c) end
	if lab2==tc:GetFieldID() then cg:AddCard(tc) end
	Duel.Hint(HINT_CARD,0,87470001) 
	Duel.SendtoDeck(cg,nil,2,REASON_EFFECT) 
	e:Reset() 
end 
function c87470001.dsrtg(e,c) 
	return c:IsCode(e:GetLabel()) and c:IsLocation(LOCATION_DECK)
end 
function c87470001.xckfil(c,code)
	return c:IsCode(code) 
end 
function c87470001.tdfil(c,turn) 
	return c:IsAbleToDeck() and c:GetTurnID()~=turn and not c:IsCode(87470001) 
end 
function c87470001.xckop(e,tp,eg,ep,ev,re,r,rp) 
	local x,code,turn=e:GetLabel() 
	if ep==e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(c87470001.xckfil,nil,code)
	if dg:GetCount()>0 and x==0 and Duel.IsExistingMatchingCard(c87470001.tdfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,turn) and Duel.SelectYesNo(tp,aux.Stringid(87470001,0)) then 
	e:SetLabel(1,code,turn) 
	Duel.Hint(HINT_CARD,0,87470001) 
	local sg=Duel.GetMatchingGroup(c87470001.tdfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,Duel.GetTurnCount())
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end
	Duel.ShuffleHand(ep)
end
function c87470001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c87470001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c87470001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) 
	c:CompleteProcedure() 
end 
function c87470001.ackfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end 
function c87470001.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsCode(87470001) and eg:IsExists(c87470001.ackfil,1,nil) end 
end 
function c87470001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=eg:FilterCount(c87470001.ackfil,nil)
	if x>0 and c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(x*1200) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)
	end 
end 
function c87470001.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c87470001.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==12 then
		e:GetLabelObject():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
	end
end







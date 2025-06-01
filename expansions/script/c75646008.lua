--崩坏学园 琪亚娜&雷电芽衣
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c0),4,3)
	c:EnableReviveLimit()
	--eq2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,id)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	s.xyz_effect=e1
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.chaincon)
	e2:SetOperation(s.chainop)
	c:RegisterEffect(e2)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.cfilter(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,id)==0 and Duel.GetFlagEffect(tp,id+1)==0
	local b2=e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xc2c1) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 and Duel.GetFlagEffect(tp,id+2)==0 
	local b3=e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x52c2) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,id)==0 and Duel.GetFlagEffect(tp,id+3)==0
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,sel+1))
	if sel==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	 elseif sel==1 then 
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
		Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(tp,id+3,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2c0))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function s.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) and es:GetEquipTarget()==e:GetHandler() and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(s.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end  
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
--爆苍的取引
local s, id = GetID()
s.named_with_RoaringAzure=1
function s.RoaringAzure(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_RoaringAzure
end
   
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.actcost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end


local CODE_HURACAN = 40020569

function s.cfilter(c)
	return c:IsCode(CODE_HURACAN) and c:IsReleasable()
end

function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	if chk==0 then return true end

	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_PZONE,0,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_PZONE,0,1,1,nil)
		if Duel.Release(g,REASON_COST)>0 then
			e:SetLabel(1) 

			Duel.SetChainLimit(s.chainlm)
		end
	end
end

function s.chainlm(e,rp,tp)
	return tp==rp
end

function s.draw_filter(c)
	return s.RoaringAzure(c)
end

function s.buff_filter(c)
	return s.RoaringAzure(c) and c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.buff_filter(chkc) end

	local b1=Duel.IsPlayerCanDraw(tp,3)

	local b2=Duel.IsExistingTarget(s.buff_filter,tp,LOCATION_MZONE,0,1,nil)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif b1 then
		op=0
	else
		op=1
	end
	
	e:SetLabel(e:GetLabel() + (op * 10)) 
	
	if op==0 then

		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_TODECK)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	else

		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.buff_filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local val = e:GetLabel()
	local op = math.floor(val / 10)
	
	if op==0 then
		if Duel.Draw(tp,3,REASON_EFFECT)==3 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			local rag=g:Filter(s.RoaringAzure,nil)
			
			if g:GetCount()>=2 and rag:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)

				local sg1=rag:Select(tp,1,1,nil)
				local tc1=sg1:GetFirst()
				
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local g2=g:Clone()
				g2:RemoveCard(tc1)
				local sg2=g2:Select(tp,1,1,nil)
				
				sg1:Merge(sg2)
				Duel.ConfirmCards(1-tp,sg1)
				Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
			else

				Duel.ConfirmCards(1-tp,g)

				while g:GetCount()>0 do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
					local tc=g:Select(tp,1,1,nil):GetFirst()
					Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
					g:RemoveCard(tc)
				end
			end
		end
	else

		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
end


function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc = re and re:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DISCARD) 
		and c:IsPreviousLocation(LOCATION_HAND)
		and rc and s.RoaringAzure(rc)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end
